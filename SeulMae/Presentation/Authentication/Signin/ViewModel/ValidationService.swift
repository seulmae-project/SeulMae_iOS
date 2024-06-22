//
//  ValidationService.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import RxSwift
import Foundation

enum ValidationResult {
    case ok(message: String)
    case empty
    case validating
    case failed(message: String)
}

extension ValidationResult {
    var isValid: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

enum SignupState {
    case signedUp(signedUp: Bool)
}

protocol ValidationService {
    func validateEmail(_ eamil: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
}

extension CharacterSet: Extended {}
extension Extension where ExtendedType == CharacterSet {

    static let emailAllowed: CharacterSet = {
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "@._-")
        return allowed
    }()
    
    static let specialCharacters: CharacterSet = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:'\",.<>?/`~")
    
    static let letters: CharacterSet = .lowercaseLetters.union(.uppercaseLetters)
}

class DefaultValidationService: ValidationService {
    
    // static let shared = DefaultValidationService(API: GitHubDefaultAPI.sharedAPI)
    
    // let API: GitHubAPI

    let minPasswordCount: Int = 8

//    init (API: GitHubAPI) {
//        self.API = API
//    }
    
    func validateEmail(_ email: String) -> RxSwift.Observable<ValidationResult> {
        if email.isEmpty {
            return .just(.empty)
        }
        
        if let invertedSet = email.rangeOfCharacter(from: .ext.emailAllowed.inverted) {
            return .just(.failed(message: "invalid characters: \(invertedSet)"))
        }
        
        let loadingValue = ValidationResult.validating
        
//        return API
//            .emailAvailable(email)
//            .map { available -> ValidationResult in
//                return available ? .ok(message: "Username available") :
//                    .failed(message: "Username already taken")
//            }
//            .startWith(loadingValue)
        
        return .just(.ok(message: "Username available"))
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 { return .empty }
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "password must be at least \(minPasswordCount) characters")
        }
    
        let containsLetters = password.rangeOfCharacter(from: .ext.letters) != nil
        let containsDigits = password.rangeOfCharacter(from: .decimalDigits) != nil
        let containsSpecialCharacters = password.rangeOfCharacter(from: .ext.specialCharacters) != nil
        if !(containsLetters && containsDigits && containsSpecialCharacters) {
            return .failed(message: "password must contain alphabets, numbers, and special characters")
        }
        
        return .ok(message: "password acceptable")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        return repeatedPassword == password ? .ok(message: "Password repeated") : .failed(message: "Password different")
    }
}

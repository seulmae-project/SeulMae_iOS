//
//  ValidationService.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import RxSwift
import Foundation

enum ValidationResult {
    case `default`(message: String)
    case ok(message: String)
    case empty(message: String)
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
    func validatePhoneNumber(_ phoneNumber: String) -> Observable<ValidationResult>
    func validateUserID(_ userID: String) -> RxSwift.Observable<ValidationResult>
    func validateEmail(_ eamil: String) -> Observable<ValidationResult>
    func validatePassword(_ password: String) -> ValidationResult
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult
    func validateUsername(_ username: String) -> Observable<ValidationResult>
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
    
    static let shared = DefaultValidationService()
    
    let minPasswordCount: Int = 8
    let minUserIDCount: Int = 5

    private init() {}
    
    // MARK: Phone Number
    
    func validatePhoneNumber(_ phoneNumber: String) -> RxSwift.Observable<ValidationResult> {
        if phoneNumber.isEmpty {
            return .just(.empty(message: ""))
        }
        
        let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
        if !cleanedPhoneNumber.allSatisfy({ $0.isNumber }) {
            return .just(.failed(message: "휴대폰 번호는 숫자만 입력 가능합니다."))
        }
        
        if !(cleanedPhoneNumber.count == 11) {
            return .just(.failed(message: "휴대폰 번호 11자리를 모두 입력해주세요"))
        }
        
        return .just(.ok(message: ""))
    }
    
    // MARK: UserID
    
    func validateUserID(_ accountID: String) -> RxSwift.Observable<ValidationResult> {
        let numberOfCharacters = accountID.count
        if numberOfCharacters == 0 { return .just(.empty(message: "")) }
        if numberOfCharacters < minPasswordCount {
            return .just(.failed(message: "영문, 숫자 포함 \(minUserIDCount)자 이상 입력해주세요"))
        }
        let pattern = "^[a-z]+[a-z0-9]{5,19}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: accountID.utf16.count)
        if regex?.firstMatch(in: accountID, options: [], range: range) == nil {
            return .just(.failed(message: "유효하지 않은 문자열입니다."))
        }
        return .just(.ok(message: "사용가능한 아이디입니다"))
    }
    
    // MARK: Email
    
    func validateEmail(_ email: String) -> RxSwift.Observable<ValidationResult> {
        if email.isEmpty {
            return .just(.empty(message: ""))
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
    
    // MARK: Password
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        let message = "영문, 숫자, 특수문자 포함 8자 이상"
        if numberOfCharacters == 0 { return .empty(message: message) }
        if numberOfCharacters < minPasswordCount {
            return .failed(message: message)
            // password must be at least \(minPasswordCount) characters
        }
    
        let containsLetters = password.rangeOfCharacter(from: .ext.letters) != nil
        let containsDigits = password.rangeOfCharacter(from: .decimalDigits) != nil
        let containsSpecialCharacters = password.rangeOfCharacter(from: .ext.specialCharacters) != nil
        if !(containsLetters && containsDigits && containsSpecialCharacters) {
            return .failed(message: message)
            // password must contain alphabets, numbers, and special characters
        }
        
        return .ok(message: message) // password acceptable
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        return repeatedPassword == password ? .ok(message: "비밀번호가 일치합니다") : .failed(message: "비밀번호가 일치하지 않습니다")
        // Password repeated
        // Password different
    }
    
    // MARK: Username
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty(message: ""))
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "Username can only contain numbers or digits"))
        }
        
        return .just(.ok(message: "Username available"))
            .startWith(.validating)
    }
}

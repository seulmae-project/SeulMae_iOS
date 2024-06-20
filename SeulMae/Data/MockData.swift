//
//  MockData.swift
//  SeulMae
//
//  Created by 조기열 on 6/20/24.
//

import Foundation


// MARK: - User

var signupResponse_success: BaseResponseDTO<String> = load("signup-success.json")
var requestSmsCertificationResponse_success: BaseResponseDTO<EmailDTO> = load("sms-certification-send-success.json")
var authCodeCertificationResponse_success: BaseResponseDTO<String> = load("sms-certification-confirm-success.json")
var emailValidationResponse_true: BaseResponseDTO<Bool> = load("email-duplication-true-success.json")
var emailValidationResponse_false: BaseResponseDTO<Bool> = load("email-duplication-false-success.json")
var signinResponse_success: BaseResponseDTO<AuthDataDTO> = load("signin-success.json")
var signinResponse_failed: BaseResponseDTO<String> = load("signin-failed.json")
var passwordRecoveryResponse_success: BaseResponseDTO<String> = load("password-recovery-success.json")
var passwordRecoveryResponse_failed: BaseResponseDTO<String> = load("password-recovery-failed.json")

// MARK: - Workplace

var addWorkplaceResponse_success: BaseResponseDTO<String> = load("v1-add-success.json")
var getWorkplaceListRequestResponse_success: BaseResponseDTO<[WorkplaceDTO]> = load("v1-info-all-success.json")
var getWorkplaceResponse_success: BaseResponseDTO<String> = load("v1-info-success.json")
var deleteWorkplaceResponse_success: BaseResponseDTO<String> = load("v1-delete-success.json")

func load<T: ModelType>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = T.decoder
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

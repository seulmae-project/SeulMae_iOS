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
var signinResponse_failed: BaseResponseDTO<AuthDataDTO> = load("signin-failed.json")
var passwordRecoveryResponse_success: BaseResponseDTO<String> = load("password-recovery-success.json")
var passwordRecoveryResponse_failed: BaseResponseDTO<String> = load("password-recovery-failed.json")

enum MockData {
    
    // MARK: - WorkplaceAPI
    
    enum WorkplaceAPI {
        static let addSuccess: BaseResponseDTO<Bool> = load("v1_add_workplace_success.json")
        static let workplacesSuccess: BaseResponseDTO<[WorkplaceDTO]> = load("v1_workplaces_success.json")
        static let detailSuccess: BaseResponseDTO<WorkplaceDTO> = load("v1_workplace_detail_success.json")
        static let updateSuccess: BaseResponseDTO<Bool> = load("v1_update_workplace_success.json")
        static let deleteSuccess: BaseResponseDTO<Bool> = load("v1_delete_workplace_success.json")
        static let submitApplicationSuccess: BaseResponseDTO<Bool> = load("v1_submit_application_success.json")
        static let acceptApplicationSuccess: BaseResponseDTO<Bool> = load("v1_accept_application_success.json")
        static let denyApplicationSuccess: BaseResponseDTO<Bool> = load("v1_deny_application_success.json")
        static let memberListSuccess: BaseResponseDTO<[MemberDTO]> = load("v1_member_list_success.json")
        static let memberInfoSuccess: BaseResponseDTO<MemberInfoDTO> = load("v1_member_info_success.json")
    }
    
    // MARK: - NoticeAPI

    enum NoticeAPI {
        static let addSuccess: BaseResponseDTO<Bool> = load("v1_add_notice_success.json")
        static let addFailed: BaseResponseDTO<Bool> = load("v1_add_notice_failed.json")
        static let updateSuccess: BaseResponseDTO<Bool> = load("v1_update_notice_success.json")
        static let updateFailed: BaseResponseDTO<Bool> = load("v1_update_notice_failed.json")
        static let detailSuccess: BaseResponseDTO<NoticeDetailDTO> = load("v1_notice_detail_success.json")
        static let detailFailed: BaseResponseDTO<NoticeDetailDTO> = load("v1_notice_detail_failed.json")
        static let noticesSuccess: BaseResponseDTO<[NoticeDTO]> = load("v1_notices_success.json")
        static let noticesFailed: BaseResponseDTO<[NoticeDTO]> = load("v1_notices_Failed.json")
        static let mustReadNoticesSuccess: BaseResponseDTO<[NoticeDTO]> = load("v1_must_read_notices_success.json")
        static let mainNoticesSuccess: BaseResponseDTO<[NoticeDTO]> = load("v1_main_notices_success.json")
        static let deleteSuccess: BaseResponseDTO<Bool> = load("v1_delete_notice_success.json")
        static let deleteFailed: BaseResponseDTO<Bool> = load("v1_delete_notice_failed.json")
    }
}

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

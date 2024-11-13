//
//  SMSVerificationType.swift
//  SeulMae
//
//  Created by 조기열 on 6/28/24.
//

import Foundation

enum SMSVerificationType {
    case signUp
    case idRecovery
    case pwRecovery
}

extension SMSVerificationType {
    var title: String {
        switch self {
        case .signUp:
            return "회원가입"
        case .idRecovery:
            return "아이디 찾기"
        case .pwRecovery:
            return "비밀번호 재설정"
        }
    }

    var description: String {
        switch self {
        case .signUp:
            return "본인인증을 위한 이름과 휴대폰 번호를 입력해주세요"
        case .idRecovery:
            return "가입시 입력하신 이름과 휴대폰 번호를 입력해주세요"
        case .pwRecovery:
            return "가입시 입력하신 이름과 휴대폰 번호를 입력해주세요"
        }
    }
    
    var sendingType: String {
        switch self {
        case .signUp:
            return "SIGNUP"
        case .idRecovery:
            return "FIND_ACCOUNT_ID"
        case .pwRecovery:
            return "CHANGE_PW"
        }
    }
}

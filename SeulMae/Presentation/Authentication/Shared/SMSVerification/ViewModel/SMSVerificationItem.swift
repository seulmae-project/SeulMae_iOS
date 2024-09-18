//
//  SMSVerificationItem.swift
//  SeulMae
//
//  Created by 조기열 on 6/28/24.
//

import Foundation

enum SMSVerificationItem {
    case signup
    case accountRecovery
    case passwordRecovery(account: String)
}

extension SMSVerificationItem {
    var isNeedAccount: Bool {
        switch self {
        case .passwordRecovery(account: _):
            return true
        default:
            return false
        }
    }
    
    var navItemTitle: String {
        switch self {
        case .signup:
            return  "회원가입"
        case .accountRecovery:
            return "아이디 찾기"
        case .passwordRecovery:
            return "비밀번호 재설정"
        }
    }
    
    var title: String {
        switch self {
        case .signup:
            return  "정보 확인을 위해\n휴대폰번호를 입력해주세요"
        case .accountRecovery:
            return "가입시 입력하신\n휴대폰 번호를 입력해주세요"
        case .passwordRecovery:
            return "가입시 입력하신 계정 아이디와\n휴대폰 번호를 입력해주세요"
        }
    }
    
    var smsVerificationType: String {
        switch self {
        case .signup:
            return "signUp"
        case .accountRecovery:
            return "findAccountId"
        case .passwordRecovery:
            return "findPassword"
        }
    }
}

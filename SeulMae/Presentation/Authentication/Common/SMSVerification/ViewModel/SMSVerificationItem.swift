//
//  SMSVerificationItem.swift
//  SeulMae
//
//  Created by 조기열 on 6/28/24.
//

import Foundation

enum SMSVerificationItem {
    case signup, idRecovery, passwordRecovery
}

extension SMSVerificationItem {
    var isHiddenAccountIDField: Bool {
        [.passwordRecovery, .signup].contains(self)
    }
    
    var navItemTitle: String {
        switch self {
        case .signup:
            return  "회원가입"
        case .idRecovery:
            return "아이디 찾기"
        case .passwordRecovery:
            return "비밀번호 재설정"
        }
    }
    
    var stepGuide: String {
        switch self {
        case .signup:
            return  "정보 확인을 위해\n휴대폰번호를 입력해주세요"
        case .idRecovery:
            return "가입시 입력하신\n휴대폰 번호를 입력해주세요"
        case .passwordRecovery:
            return "가입시 입력하신 이메일 주소와\n휴대폰 번호를 입력해주세요"
        }
    }
}

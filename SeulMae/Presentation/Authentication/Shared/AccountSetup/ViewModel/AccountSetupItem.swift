//
//  AccountSetupItem.swift
//  SeulMae
//
//  Created by 조기열 on 8/7/24.
//

import Foundation

enum AccountSetupItem {
    case signup, passwordRecovery
}

extension AccountSetupItem {
    var isHiddenAccountIDField: Bool {
        [.passwordRecovery].contains(self)
    }
    
    var navItemTitle: String {
        switch self {
        case .signup:
            return  "회원가입"
        case .passwordRecovery:
            return "비밀번호 재설정"
        }
    }
    
    var title: String {
        switch self {
        case .signup:
            return  "로그인 아이디와\n비밀번호를 입력해주세요"
        case .passwordRecovery:
            return "새로운 비밀번호를\n입력해주세요"
        }
    }
}

//
//  CompletionItem.swift
//  SeulMae
//
//  Created by 조기열 on 6/28/24.
//

import UIKit

enum CompletionItem {
    case signup(username: String), passwordRecovery
    
    var completion: String {
        switch self {
        case .signup:
            return "회원 가입 완료"
        case .passwordRecovery:
            return "비밀번호 재설정 완료"
        }
    }
    
    var stepGuide: String {
        switch self {
        case .signup(let username):
            return  "\(username)님,\n만나서 반가워요!"
        case .passwordRecovery:
            return "비밀번호 변경을\n완료했습니다."
        }
    }
    
    var nextStep: String {
        switch self {
        default:
            return  "로그인가기"
        }
    }
    
    var image: UIImage {
        return UIImage()
    }
}

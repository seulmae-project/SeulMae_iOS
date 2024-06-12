//
//  SigninViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

final class SigninViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: SigninViewModel) -> SigninViewController {
        let view = SigninViewController()
        view.viewModel = viewModel
        return view
    }
    
    enum Text {
        static let emailTextFieldPlaceholder = "이메일을 입력해주세요"
        static let passwordTextFieldPlaceholder = "비밀번호를 입력해주세요"
        static let signin = "로그인"
        static let kakaoSignin = "카카오톡 로그인"
        static let passwordReset = "비밀번호 재설정"
        static let signup = "회원가입"
    }
    
    // MARK: - Dependency
    
    private var viewModel: SigninViewModel!
    
    // MARK: - UI
    
    private let appIconImageView: UIImageView = .common(image: .actions)
    private let eamilTextField: UITextField = .common(placeholder: Text.emailTextFieldPlaceholder)
    private let passwordTextField: UITextField = .common(placeholder: Text.passwordTextFieldPlaceholder)
    private let signinButton: UIButton = .common(title: Text.signin)
    private let kakaoSigninButton: UIButton = .common(title: Text.kakaoSignin)
    private let passwordResetButton: UIButton = .common(title: Text.passwordReset)
    private let signupButton: UIButton = .common(title: Text.signup)

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
}



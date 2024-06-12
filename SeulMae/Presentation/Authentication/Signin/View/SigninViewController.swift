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
        static let passwordReset = "아이디 또는 비밀번호 찾기"
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
        
        configureNavItem()
        configureHierarchy()
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
        
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        let signinHStack = UIStackView(arrangedSubviews: [
            passwordResetButton, signupButton, passwordTextField
        ])
        signinHStack.spacing = 16
        
        let signinVStack = UIStackView(arrangedSubviews: [
            appIconImageView, eamilTextField, passwordTextField, signinButton, kakaoSigninButton, signinHStack
        ])
        signinVStack.axis = .vertical
        signinVStack.alignment = .center
        signinVStack.spacing = 8
        signinVStack.setCustomSpacing(48, after: appIconImageView)
        signinVStack.setCustomSpacing(16, after: passwordTextField)
        signinVStack.setCustomSpacing(4, after: kakaoSigninButton)
        
        signinVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(view.snp_topMargin).inset(112)
            make.centerX.equalToSuperview()
        }
        
        eamilTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(48)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(48)
        }
        
        signinButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(56)
        }
        
        kakaoSigninButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(56)
        }
    }
}



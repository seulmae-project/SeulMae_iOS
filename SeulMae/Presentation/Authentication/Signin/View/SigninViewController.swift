//
//  SigninViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa


final class SigninViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: SigninViewModel) -> SigninViewController {
        let view = SigninViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Dependency
    
    private var viewModel: SigninViewModel!
    
    // MARK: - UI
    
    private let appIconImageView: UIImageView = .common(image: .appLogo)
    private let eamilTextField: UITextField = .common(placeholder: "이메일을 입력해주세요")
    private let passwordTextField: UITextField = .password(placeholder: "비밀번호를 입력해주세요")
    
    private let signInButton: UIButton = {
        let b = UIButton()
        b.setTitle("로그인", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        b.backgroundColor = .primary
        b.layer.cornerRadius = 8.0
        b.layer.cornerCurve = .continuous
        return b
    }()
    
    private let kakaoSignInButton: UIButton = {
        let b = UIButton()
        b.setImage(.kakaoLoginLargeWide, for: .normal)
        b.contentVerticalAlignment = .fill
        b.contentHorizontalAlignment = .fill
        return b
    }()
    
    private let appleSignInButton: UIButton = {
        let b = UIButton()
        return b
    }()
    
    private let findCredentials: UIButton = .callout(title: "이메일 또는 비밀번호 찾기")
    private let signupButton: UIButton = .callout(title: "회원가입")

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {

        let output = viewModel.transform(
            .init(
                email: eamilTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                signin: signInButton.rx.tap.asSignal(),
                kakaoSignin: kakaoSignInButton.rx.tap.asSignal(),
                validateSMS: .empty(), // .just(.idRecovery)
                signup: signupButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await signedIn in output.signedIn.values {
                if !signedIn {
                    passwordTextField.text = ""
                }
            }
        }
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let signinHStack = UIStackView(arrangedSubviews: [
            findCredentials, signupButton
        ])
        signinHStack.spacing = 16
        
        let signinVStack = UIStackView(arrangedSubviews: [
            appIconImageView, eamilTextField, passwordTextField, signInButton, kakaoSignInButton, signinHStack
        ])
        signinVStack.axis = .vertical
        signinVStack.alignment = .center
        signinVStack.spacing = 8
        signinVStack.setCustomSpacing(48, after: appIconImageView)
        signinVStack.setCustomSpacing(16, after: passwordTextField)
        signinVStack.setCustomSpacing(4, after: kakaoSignInButton)
        
        view.addSubview(signinVStack)
        
        signinVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(view.snp_topMargin).inset(40)
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
        
        signInButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(56)
        }
        
        kakaoSignInButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(56)
        }
    }
}



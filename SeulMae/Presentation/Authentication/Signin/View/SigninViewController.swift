//
//  SigninViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa

enum CredentialRecoveryOption {
    case account, password
}

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
       
        // 이로 인해 UI가 겹쳐지거나, 올바르지 않은 상태에서 바텀 시트가 나타날 수 있습니다. 이러한 문제를 방지하려면, 새로운 시트를 표시하기 전에 기존 시트가 닫혔는지 확인하는 것이 좋습니다.
        let credentialOption = findCredentials.rx.tap.asSignal()
            .flatMapLatest { [weak self] _ -> Signal<CredentialRecoveryOption> in
                guard let strongSelf = self else { return .empty() }
                let viewController = CredentialRecoveryOptionsViewController()
                let credentialRecoveryOptionsBottomSheet = BottomSheetController(contentViewController: viewController)
                strongSelf.present(credentialRecoveryOptionsBottomSheet, animated: true)
                return viewController.recoveryOptionRelay
                    .asSignal()
            }

        let output = viewModel.transform(
            .init(
                email: eamilTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                signin: signInButton.rx.tap.asSignal(),
                kakaoSignin: kakaoSignInButton.rx.tap.asSignal(),
                validateSMS: .empty(), // .just(.idRecovery)
                signup: signupButton.rx.tap.asSignal(),
                credentialOption: credentialOption
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



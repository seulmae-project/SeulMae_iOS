//
//  SigninViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

enum CredentialRecoveryOption {
    case account, password
}

final class SigninViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private let appIconImageView: UIImageView = .common(image: .appLogo)
    private let eamilTextField: UITextField = .common(placeholder: "이메일을 입력해주세요")
    private let passwordTextField: UITextField = .password(placeholder: "비밀번호를 입력해주세요")
    private let signInButton: UIButton = .common(title: "로그인")
    private let kakaoSignInButton: UIButton = .image(.kakaoLoginLargeWide)
    private let appleSignInButton = ASAuthorizationAppleIDButton()
    private let findCredentials: UIButton = .callout(title: "이메일 또는 비밀번호 찾기")
    private let signupButton: UIButton = .callout(title: "회원가입")
    
    // MARK: - Properties
    
    private var authorizationController: ASAuthorizationController!
    
    // MARK: - Dependencies
    
    private var viewModel: SigninViewModel!
    
    // MARK: - Life Cycle
    
    init(viewModel: SigninViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupAuthController()
        setupConstraints()
        bindSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindSubviews() {
        let appleSignin = appleSignInButton.rx
            .controlEvent(.touchUpInside)
            .asSignal()
        
        Task {
            for await _ in  appleSignin.values {
                 authorizationController.performRequests()
            }
        }
        
        let credential = authorizationController.rx.credential
        Task {
            for await _ in  credential.asSignal().values {
                
            }
        }
       
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
                account: eamilTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                signin: signInButton.rx.tap.asSignal(),
                kakaoSignin: kakaoSignInButton.rx.tap.asSignal(),
                appleSignin: appleSignInButton.rx.controlEvent(.touchUpInside).asSignal(),
                validateSMS: .empty(), // .just(.idRecovery)
                signup: signupButton.rx.tap.asSignal(),
                credentialOption: credentialOption
            )
        )
        
        output
        
//        Task {
//            for await signedIn in output.signedIn.values {
//                if !signedIn {
//                    passwordTextField.text = ""
//                }
//            }
//        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupAuthController() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
    }
    
    // MARK: - Hierarchy

    private func setupConstraints() {
        let optionStack = UIStackView()
        optionStack.spacing = 16
        optionStack.addArrangedSubview(findCredentials)
        optionStack.addArrangedSubview(signupButton)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 8.0
        contentStack.addArrangedSubview(eamilTextField)
        contentStack.addArrangedSubview(passwordTextField)
        contentStack.addArrangedSubview(signInButton)
        contentStack.addArrangedSubview(kakaoSignInButton)
        contentStack.addArrangedSubview(appleSignInButton)
        contentStack.setCustomSpacing(16, after: passwordTextField)

        view.addSubview(appIconImageView)
        view.addSubview(contentStack)
        view.addSubview(optionStack)
        
        appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        optionStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 40),
            
            optionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            optionStack.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 4),
            
            // Constraint textfields height
            eamilTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Constraint buttons height
            signInButton.heightAnchor.constraint(equalToConstant: 56),
            kakaoSignInButton.heightAnchor.constraint(equalToConstant: 56),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

// MAKR: - ASAuthorizationControllerPresentationContextProviding

extension SigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}



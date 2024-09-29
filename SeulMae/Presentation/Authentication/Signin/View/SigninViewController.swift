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

final class SigninViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let titleLabel: UILabel = .common(title: "로그인", size: 24, weight: .semibold)
    // private let appIconImageView: UIImageView = .common(image: .appLogo)
    private let idTextField: UITextField = .common(placeholder: "아이디를 입력해주세요")
    private let passwordTextField: UITextField = .password(placeholder: "비밀번호를 입력해주세요")
    private let signInButton: UIButton = .common(title: "로그인", size: 18, weight: .medium)
    private let accountRecoveryButton: UIButton = .common(title: "아이디 또는 비밀번호 찾기", color: .signinText, backgroundColor: nil)
    private let dotLabel: UILabel = .common(title: "·", color: .signinText)
    private let signupButton: UIButton = .common(title: "회원가입", color: .signinText, backgroundColor: nil)
    private let orLabel: UILabel = .common(title: "OR", color: .signinText)
    private let kakaoSignInButton: UIButton = .image(.kakaoLogin)
    private let appleSignInButton: UIButton = .image(.appleLogin)
    
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
        // handle textField enter
        Task {
            for await _ in idTextField.rx.controlEvent(.editingDidEndOnExit).asDriver().values {
                passwordTextField.becomeFirstResponder()
            }
        }
        
        let appleSignin = appleSignInButton.rx.tap.asSignal()
        
        Task {
            for await _ in appleSignin.values {
                 authorizationController.performRequests()
            }
        }
        
        let credential = authorizationController.rx.credential
        Task {
            for await _ in credential.asSignal().values {
                
            }
        }

        let output = viewModel.transform(
            .init(
                userID: idTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                signin: signInButton.rx.tap.asSignal(),
                kakaoSignin: kakaoSignInButton.rx.tap.asSignal(),
                appleSignin: appleSignInButton.rx.tap.asSignal(),
                accountRecovery: accountRecoveryButton.rx.tap.asSignal(),
                signup: signupButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await loading in output.loading.values {
                loadingIndicator.ext.isAnimating(loading)
            }
        }
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
        let socialLoginStack = UIStackView()
        socialLoginStack.spacing = 8.0
        socialLoginStack.distribution = .fillEqually
        socialLoginStack.addArrangedSubview(appleSignInButton)
        socialLoginStack.addArrangedSubview(kakaoSignInButton)
        
        let separatorStack = UIStackView()
        separatorStack.spacing = 16
        separatorStack.alignment = .center
        let leftSeparator = UIView.separator
        let rightSeparator = UIView.separator
        separatorStack.addArrangedSubview(leftSeparator)
        separatorStack.addArrangedSubview(orLabel)
        separatorStack.addArrangedSubview(rightSeparator)
       
        let optionStack = UIStackView()
        optionStack.spacing = 4.0
        optionStack.addArrangedSubview(accountRecoveryButton)
        optionStack.addArrangedSubview(dotLabel)
        optionStack.addArrangedSubview(signupButton)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.addArrangedSubview(idTextField)
        contentStack.addArrangedSubview(passwordTextField)
        contentStack.addArrangedSubview(signInButton)
        
        view.addSubview(titleLabel)
        // view.addSubview(appIconImageView)
        view.addSubview(contentStack)
        view.addSubview(optionStack)
        view.addSubview(separatorStack)
        view.addSubview(socialLoginStack)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        // appIconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        optionStack.translatesAutoresizingMaskIntoConstraints = false
        separatorStack.translatesAutoresizingMaskIntoConstraints = false
        socialLoginStack.translatesAutoresizingMaskIntoConstraints = false
        
        let insets = CGFloat(20)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            // appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            
            optionStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            optionStack.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 8.0),
            
            separatorStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            separatorStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorStack.topAnchor.constraint(equalTo: optionStack.bottomAnchor, constant: 36),
            // TODO: - handle separator layout error
            
            socialLoginStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            socialLoginStack.topAnchor.constraint(equalTo: separatorStack.bottomAnchor, constant: 36),
            
            // Constraint separator width
            leftSeparator.widthAnchor.constraint(equalTo: rightSeparator.widthAnchor),
            
            // Constraint textfields height
            idTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Constraint buttons height
            signInButton.heightAnchor.constraint(equalToConstant: 56),
            kakaoSignInButton.heightAnchor.constraint(equalToConstant: 56),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 56),
            kakaoSignInButton.widthAnchor.constraint(equalToConstant: 56),
            appleSignInButton.widthAnchor.constraint(equalToConstant: 56),
        ])
    }
}

// MAKR: - ASAuthorizationControllerPresentationContextProviding

extension SigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}

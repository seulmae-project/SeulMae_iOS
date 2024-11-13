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

final class SigninViewController: BaseViewController {
    
    // MARK: - UI Properties

    private let appIconImageView = UIImageView.ext.common(.signinAppIcon)
        .ext.size(width: 60, height: 37)

    private let idTextFieldRightView = UIButton.ext.image(.idIconUnSelected)
        .ext.frame(width: 28, height: 28)
    private lazy var idTextField = UITextField.ext.tf()
        .ext.backgroundColor("F2F5FF")
        .ext.font(.pretendard(size: 16, weight: .regular))
        .ext.placeholder("아이디를 입력해주세요", textColor: .ext.hex("CAD1EA"))
        .ext.rightView(idTextFieldRightView)

    private let pwTextFieldRightView = UIButton.ext.image(.pwIconUnSelected)
        .ext.frame(width: 28, height: 28)
    private lazy var pwTextField = UITextField.ext.tf()
        .ext.backgroundColor("F2F5FF")
        .ext.font(.pretendard(size: 16, weight: .regular))
        .ext.placeholder("비밀번호를 입력해주세요", textColor: .ext.hex("CAD1EA"))
        .ext.rightView(pwTextFieldRightView)
        .ext.pw()

    private let signInButton = UIButton.ext.common(title: "로그인")
    private let idRecoveryButton = UIButton.ext.text("아이디 찾기")
        .ext.font(.pretendard(size: 12, weight: .regular))
    private let pwRecoveryButton = UIButton.ext.text("비밀번호 찾기")
        .ext.font(.pretendard(size: 12, weight: .regular))
    private let signupButton = UIButton.ext.text("회원가입")
        .ext.font(.pretendard(size: 12, weight: .regular))

    private let kakaoSignInButton = UIButton.ext.image(.signinKakaoButton)
        .ext.size(width: 142, height: 40)
    private let appleSignInButton = UIButton.ext.image(.signinAppleButton)
        .ext.size(width: 142, height: 40)

    // MARK: - Properties
    
    private var authorizationController: ASAuthorizationController!
    
    // MARK: - Dependencies
    
    private var viewModel: SigninViewModel!

    // MARK: - Life Cycle
    
    convenience init(viewModel: SigninViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureAuthController()
        bindInternalSubviews()
        idTextField.text = "yonggipo"
        pwTextField.text = "a**4579225"
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        // handle textField enter
        idTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretained(self)
            .subscribe(onNext: { (self, _) in
                self.pwTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        // merge pw text field enter and signin button tap
        let onEnter = pwTextField.rx.controlEvent(.editingDidEndOnExit).asSignal()
        let onSignIn = Signal.merge(onEnter, signInButton.rx.tap.asSignal())

        // handle apple signin
        appleSignInButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (self, _) in
                self.authorizationController.performRequests()
            })
            .disposed(by: disposeBag)

        let output = viewModel.transform(
            .init(
                onLoad: onLoad,
                onRefresh: .empty(),
                id: idTextField.rx.text.orEmpty.asDriver(),
                pw: pwTextField.rx.text.orEmpty.asDriver(),
                signin: onSignIn,
                kakaoSignin: kakaoSignInButton.rx.tap.asSignal(),
                appleSignin: authorizationController.rx.credential.asSignal(),
                idRecovery: idRecoveryButton.rx.tap.asSignal(),
                pwRecovery: pwRecoveryButton.rx.tap.asSignal(),
                signup: signupButton.rx.tap.asSignal()
            )
        )

        output.loading.drive(loadingIndicator.ext.isAnimating)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Methods
    
    private func configureAuthController() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let textFieldStack = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 16
            [idTextField, pwTextField, signInButton]
                .forEach($0.addArrangedSubview(_:))
        }

        let optionStack = UIStackView().then {
            $0.spacing = 16
            $0.distribution = .equalSpacing
            [idRecoveryButton, Ext.divider, pwRecoveryButton, Ext.divider, signupButton]
                .forEach($0.addArrangedSubview(_:))
        }

        let socialLoginStack = UIStackView().then {
            $0.spacing = 8.0
            $0.distribution = .fillEqually
            [appleSignInButton, kakaoSignInButton]
                .forEach($0.addArrangedSubview(_:))
        }

        let views = [appIconImageView, textFieldStack, optionStack, socialLoginStack]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let insets = CGFloat(24)
        appIconImageView
            .ext.centerX(match: view.centerXAnchor)
            .ext.fromTop(to: view.safeAreaLayoutGuide.topAnchor, constant: 66)
        textFieldStack
            .ext.centerX(match: view.centerXAnchor)
            .ext.fromLeading(to: view.leadingAnchor, constant: insets)
            .ext.fromTop(to: appIconImageView.bottomAnchor, constant: 40)

        optionStack
            .ext.centerX(match: view.centerXAnchor)
            .ext.size(height: 16)
            .ext.fromTop(to: textFieldStack.bottomAnchor, constant: 28)

        socialLoginStack
            .ext.centerX(match: view.centerXAnchor)
            .ext.fromTop(to: optionStack.bottomAnchor, constant: 55)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension SigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}

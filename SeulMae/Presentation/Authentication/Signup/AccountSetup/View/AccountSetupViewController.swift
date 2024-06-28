//
//  AccountSetupViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

final class AccountSetupViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: AccountSetupViewModel) -> AccountSetupViewController {
        let view = AccountSetupViewController()
        view.viewModel = viewModel
        return view
    }
    
    enum Text {
        static let stepGuide = "로그인 이메일과\n비밀번호를 입력해주세요"
        static let emailFieldGuide = "이메일"
        static let emailTextFieldPlaceholder = "이메일 입력"
        static let emailValidation = "중복확인"
        static let secondEmailFieldGuideLabel = "사용가능한 이메일입니다"
        static let passwordFieldGuide = "비밀번호"
        static let passwordTextFieldPlaceholder = "비밀번호 입력"
        static let secondPasswordFeildGuide = "영문, 숫자, 특수문자 포함 8자 이상"
        static let repeatedPasswordFieldGuide = "비밀번호 재입력"
        static let repeatedPasswordTextFieldPlaceholder = "비밀번호 재입력"
        static let secondRepeatedPasswordFieldGuideLabel = "비밀번호가 일치합니다"
        static let nextStep = "다음으로"
    }
    
    // MARK: - Dependency
    
    private var viewModel: AccountSetupViewModel!
    
    // MARK: - UI
    
    private let stepGuideLabel: UILabel = .title(title: Text.stepGuide)
    private let emailFieldGuideLabel: UILabel = .callout(title: Text.emailFieldGuide)
    private let emailTextField: UITextField = .common(placeholder: Text.emailTextFieldPlaceholder)
    private let userIDVerificationButton: UIButton = .common(title: Text.emailValidation, cornerRadius: 16)
    private let userIDValidationResultLabel: UILabel = .footnote(title: Text.secondEmailFieldGuideLabel)
    private let passwordFieldGuideLabel: UILabel = .callout(title: Text.passwordFieldGuide)
    private let passwordTextField: UITextField = .common(placeholder: Text.passwordTextFieldPlaceholder)
    private let passwordValidationResultLabel: UILabel = .footnote(title: Text.secondPasswordFeildGuide)
    private let repeatedPasswordFieldGuideLabel: UILabel = .callout(title: Text.repeatedPasswordFieldGuide)
    private let repeatedPasswordTextField: UITextField = .common(placeholder: Text.repeatedPasswordTextFieldPlaceholder)
    private let repeatedPasswordValidationResultLabel: UILabel = .footnote(title: Text.secondRepeatedPasswordFieldGuideLabel)
    private let nextStepButton: UIButton = .common(title: Text.nextStep)
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindInternalSubviews()
        configureNavItem()
        configureHierarchy()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        
        let tapBackground = UITapGestureRecognizer()
        Task {
            for try await _ in tapBackground.rx.event.values {
                view.endEditing(true)
            }
        }
        
        view.addGestureRecognizer(tapBackground)

        let output = viewModel.transform(
            .init(
                userID: emailTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordTextField.rx.text.orEmpty.asDriver(),
                verifyUserID: userIDVerificationButton.rx.tap.asSignal(),
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await result in output.validatedUserID.values {
                userIDValidationResultLabel.ext.setResult(result)
            }
        }
        
        Task {
            for await isEnabled in output.userIDVerificationEnabled.values {
                userIDVerificationButton.ext.setEnabled(isEnabled)
            }
        }
    
        Task {
            for await _ in output.verifiedUserID.values {
                
            }
        }
        
        Task {
            for await result in output.validatedPassword.values {
                passwordValidationResultLabel.ext.setResult(result)
            }
        }
        
        Task {
            for await result in output.validatedRepeatedPassword.values {
                repeatedPasswordValidationResultLabel.ext.setResult(result)
            }
        }
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
        navigationItem.title = signup
    }

    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let emailFieldHStack = UIStackView(arrangedSubviews: [
            emailTextField, userIDVerificationButton
        ])
        emailFieldHStack.spacing = 8.0
        emailFieldHStack.distribution = .fillProportionally
        
        let emailFieldVStack = UIStackView(arrangedSubviews: [
            emailFieldGuideLabel, emailFieldHStack
        ])
        emailFieldVStack.axis = .vertical
        
        let passwordFieldStack = UIStackView(arrangedSubviews: [
            passwordFieldGuideLabel, passwordTextField, passwordValidationResultLabel
        ])
        passwordFieldStack.axis = .vertical
        passwordFieldStack.setCustomSpacing(8.0, after: passwordTextField)
        
        let repeatedPasswordFieldStack = UIStackView(arrangedSubviews: [
            repeatedPasswordFieldGuideLabel, repeatedPasswordTextField
        ])
        repeatedPasswordFieldStack.axis = .vertical
        
        let subViews: [UIView] = [
            stepGuideLabel, emailFieldVStack, passwordFieldStack, repeatedPasswordFieldStack, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        stepGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(24)
            make.centerX.equalToSuperview()
        }
        
        emailFieldVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(stepGuideLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
        }
        
        userIDVerificationButton.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(48)
        }
        
        passwordFieldStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(emailFieldVStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        repeatedPasswordFieldStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(passwordFieldStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        repeatedPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
}

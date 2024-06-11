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
        static let passwordFieldGuide = "비밀번호"
        static let passwordTextFieldPlaceholder = "비밀번호 입력"
        static let secondPasswordFeildGuide = "영문, 숫자, 특수문자 포함 8자 이상"
        static let repeatedPasswordFieldGuide = "비밀번호 재입력"
        static let repeatedPasswordTextFieldPlaceholder = "비밀번호 재입력"
        static let nextStep = "다음으로"
    }
    
    // MARK: - Dependency
    
    private var viewModel: AccountSetupViewModel!
    
    // MARK: - UI
    
    private var stepGuideLabel: UILabel = UIViewController.createTitleGuideLabel(title: Text.stepGuide)
    private var emailFieldGuideLabel: UILabel = UIViewController.createTextFiledGuideLabel(title: Text.emailFieldGuide)
    private var emailTextField: UITextField = UIViewController.createTextField(placeholder: Text.emailTextFieldPlaceholder)
    private var emailValidationButton: UIButton = UIViewController.createButton(title: Text.emailValidation, cornerRadius: 16)
    private var passwordFieldGuideLabel: UILabel = UIViewController.createTextFiledGuideLabel(title: Text.passwordFieldGuide)
    private var passwordTextField: UITextField = UIViewController.createTextField(placeholder: Text.passwordTextFieldPlaceholder)
    private var secondPasswordFieldGuideLabel: UILabel = UIViewController.createSecondTextFieldGuideLabel(title: Text.secondPasswordFeildGuide)
    private var repeatedPasswordFieldGuideLabel: UILabel = UIViewController.createTextFiledGuideLabel(title: Text.repeatedPasswordFieldGuide)
    private var repeatedPasswordTextField: UITextField = UIViewController.createTextField(placeholder: Text.repeatedPasswordTextFieldPlaceholder)
    private var nextStepButton: UIButton = UIViewController.createButton(title: Text.nextStep)
    
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
        let emailFieldHStack = UIStackView(arrangedSubviews: [
            emailTextField, emailValidationButton
        ])
        emailFieldHStack.spacing = 8.0
        emailFieldHStack.distribution = .fillProportionally
        
        let emailFieldVStack = UIStackView(arrangedSubviews: [
            emailFieldGuideLabel, emailFieldHStack
        ])
        emailFieldVStack.axis = .vertical
        
        let passwordFieldStack = UIStackView(arrangedSubviews: [
            passwordFieldGuideLabel, passwordTextField, secondPasswordFieldGuideLabel
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
        
        emailFieldHStack.snp.makeConstraints { make in
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

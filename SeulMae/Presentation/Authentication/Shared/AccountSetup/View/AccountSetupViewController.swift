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
    
    // MARK: - Dependency
    
    private var viewModel: AccountSetupViewModel!
    
    // MARK: - UI
    
    private let titleLabel: UILabel = .title()
    private let accountIDLabel: UILabel = .callout(title: "아이디")
    private let accountIDTextField: UITextField = .common(placeholder: "아이디 입력")
    private let validateAccountIDButton: UIButton = .common(title: "중복확인", cornerRadius: 16)
    private let accountIDValidationResultLabel: UILabel = .footnote(title: "")
    private lazy var accountIDStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [
            accountIDTextField, validateAccountIDButton
        ])
        hStack.spacing = 8.0
        hStack.distribution = .fillProportionally
        let vStack = UIStackView(arrangedSubviews: [
            accountIDLabel, hStack
        ])
        vStack.axis = .vertical
        vStack.spacing = 8.0
        return vStack
    }()
    private let passwordLabel: UILabel = .callout(title: "비밀번호")
    private let passwordTextField: UITextField = .password(placeholder: "비밀번호 입력")
    private let passwordValidationResultLabel: UILabel = .footnote(title: "")
    private let repeatedPasswordLabel: UILabel = .callout(title: "비밀번호 재입력")
    private let repeatedPasswordTextField: UITextField = .password(placeholder: "비밀번호 재입력")
    private let repeatedPasswordValidationResultLabel: UILabel = .footnote(title: "")
    private let nextStepButton: UIButton = .common(title: "다음으로")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 사용하시겠습니까 -> 고정바꿀 수 없도록..?
        
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        // Handle Background Tap
        let tapBackground = UITapGestureRecognizer()
        Task {
            for await _ in tapBackground.rx.event.asSignal().values {
                view.endEditing(true)
            }
        }
        view.addGestureRecognizer(tapBackground)
        
        // Handle TextField Max Length
        let accountIDMaxLength = 12
        let accountID = accountIDTextField.rx
            .text
            .orEmpty
            .map { String($0.prefix(accountIDMaxLength)) }
            .asDriver()
        
        Task {
            for await accountID in accountID.values {
                accountIDTextField.text = accountID
            }
        }
        
        // Handle Output
        let output = viewModel.transform(
            .init(
                accountID: accountID,
                verifyAccountID: validateAccountIDButton.rx.tap.asSignal(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordTextField.rx.text.orEmpty.asDriver(),
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        // Handle View Item
        Task {
            for await item in output.item.values {
                titleLabel.text = item.title
                navigationItem.title = item.navItemTitle
                accountIDStack.isHidden = item.isHiddenAccountIDField
            }
        }
        
        //
        Task {
            for await isAvailable in output.isAvailable.values {
                print(isAvailable)
            }
        }
        
        // Handle Button Enable State
        Task {
            for await isEnabled in output.validateAccountIDEnabled.values {
                validateAccountIDButton.ext.setEnabled(isEnabled)
            }
        }
        
        // Handle Validation Result Message
        Task {
            for await result in output.validatedAccountID.values {
                accountIDValidationResultLabel.ext.setResult(result)
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
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let pwVStack = UIStackView(arrangedSubviews: [
            passwordLabel, passwordTextField
        ])
        pwVStack.axis = .vertical
        pwVStack.spacing = 8.0
        
        let repeatedPWVStack = UIStackView(arrangedSubviews: [
            repeatedPasswordLabel, repeatedPasswordTextField
        ])
        repeatedPWVStack.axis = .vertical
        repeatedPWVStack.spacing = 8.0
        
        let inputsVStack = UIStackView(arrangedSubviews: [
            accountIDStack, pwVStack, repeatedPWVStack
        ])
        inputsVStack.axis = .vertical
        inputsVStack.spacing = 40
        
        let subViews: [UIView] = [
            titleLabel, inputsVStack, nextStepButton, accountIDValidationResultLabel, passwordValidationResultLabel, repeatedPasswordValidationResultLabel
        ]
        subViews.forEach(view.addSubview)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(24)
            make.centerX.equalToSuperview()
        }
        
        validateAccountIDButton.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(48)
        }
        
        inputsVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
        }
        
        [passwordTextField, repeatedPasswordTextField].forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
        
        // Validation Labels Layout
        accountIDValidationResultLabel.snp
            .makeConstraints { make in
                make.leading
                    .equalTo(accountIDStack.snp.leading)
                make.top
                    .equalTo(accountIDStack.snp.bottom)
                    .offset(8)
            }
        
        passwordValidationResultLabel.snp
            .makeConstraints { make in
                make.leading
                    .equalTo(pwVStack.snp.leading)
                make.top
                    .equalTo(pwVStack.snp.bottom)
                    .offset(8)
            }
        
        repeatedPasswordValidationResultLabel.snp
            .makeConstraints { make in
                make.leading
                    .equalTo(repeatedPWVStack.snp.leading)
                make.top
                    .equalTo(repeatedPWVStack.snp.bottom)
                    .offset(8)
            }
    }
}

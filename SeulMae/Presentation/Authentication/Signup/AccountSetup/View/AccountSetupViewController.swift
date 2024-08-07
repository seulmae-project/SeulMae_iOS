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
    private let accountIDValidationResultLabel: UILabel = .footnote(title: "사용가능한 아이디입니다")
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
    private let passwordTextField: UITextField = .common(placeholder: "비밀번호 입력")
    private let passwordValidationResultLabel: UILabel = .footnote(title: "영문, 숫자, 특수문자 포함 8자 이상")
    private let repeatedPasswordLabel: UILabel = .callout(title: "비밀번호 재입력")
    private let repeatedPasswordTextField: UITextField = .common(placeholder: "비밀번호 재입력")
    private let repeatedPasswordValidationResultLabel: UILabel = .footnote(title: "비밀번호가 일치합니다")
    private let nextStepButton: UIButton = .common(title: "다음으로")
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 아이디 필드 최대 카운트
        // validation result label 안보임?
        // 사용하시겠습니까 -> 고정바꿀 수 없도록
        // 비밀번호 텍스트 필드 ******로
        // 바리데이션 결과 글 한글로
        // 두번째 패스워드 바리데이션 결과 안보임
        // 타입에 따라서 아이디 확인 없이 넘어가도록
        
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

        // Handle Output
        let output = viewModel.transform(
            .init(
                userID: accountIDTextField.rx.text.orEmpty.asDriver(),
                password: passwordTextField.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordTextField.rx.text.orEmpty.asDriver(),
                verifyUserID: validateAccountIDButton.rx.tap.asSignal(),
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
        
        Task {
            for await result in output.validatedAccountID.values {
                accountIDValidationResultLabel.ext.setResult(result)
            }
        }
        
        Task {
            for await isEnabled in output.validateAccountIDEnabled.values {
                validateAccountIDButton.ext.setEnabled(isEnabled)
            }
        }
    
        Task {
            for await _ in output.validatedAccountID.values {
                
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
            passwordLabel, passwordTextField, passwordValidationResultLabel
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
        inputsVStack.spacing = 16
        
        let subViews: [UIView] = [
            titleLabel, inputsVStack, nextStepButton
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
    }
}

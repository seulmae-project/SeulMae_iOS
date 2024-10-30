//
//  SMSVerificationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import SnapKit

final class SMSVerificationViewController: BaseViewController {

    // MARK: - UI properties

    private let titleLabel = UILabel.ext.config(font: .pretendard(size: 24, weight: .semibold))
    private let descriptionLabel = UILabel.ext.config(font: .pretendard(size: 13, weight: .regular))
        .ext.highlight(font: .pretendard(size: 13, weight: .semibold), textColor: "4C71F5", words: "이름", "휴대폰 번호")
    private let usernameTextField = UITextField.ext.tf()
        .ext.placeholder("이름을 입력해주세요")
    private let phoneNumberTextField = UITextField.ext.tf()
        .ext.tel()
        .ext.placeholder("인증번호를 입력해주세요")
    private let sendSMSCodeButton = UIButton.ext.common(title: "인증번호 받기")
    private let smsCodeLabel = UILabel.ext.config(font: .pretendard(size: 14, weight: .regular))
    private let resendSMSCodeButton = UIButton.ext.small(title: "재전송")
        .ext.size(width: 72, height: 32)
    private lazy var remainingTimer = RemainingTimer().then {
        $0.setRemainingTime(minutes: 3)
        $0.onFire = { [weak self] timer in
            self?.resendSMSCodeButton.isHidden = false
        }
    }
    private let smsCodeTextField = UITextField.ext.tf()
        .ext.placeholder("인증번호 6자리 입력")
    
    private let verifySMSCodeButton = UIButton.ext.common(title: "인증번호 확인")



    // MARK: - Dependencies

    private var viewModel: SMSVerificationViewModel!

    // MARK: - Life Cycle

    convenience init(viewModel: SMSVerificationViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureNavItem()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        let phoneNumber = phoneNumberTextField.rx
            .text.orEmpty
            .asDriver()
            .ext.number
            .ext.maxLength(11)
            .ext.phoneNumberFormat

        phoneNumber.drive(phoneNumberTextField.rx.text)
            .disposed(by: disposeBag)
        
        let smsCode = smsCodeTextField.rx
            .text.orEmpty
            .asDriver()
            .ext.number
            .ext.maxLength(6)

        smsCode.drive(smsCodeTextField.rx.text)
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(
            .init(
                username: usernameTextField.rx.text.orEmpty.asDriver(),
                phoneNumber: phoneNumber,
                sendSMSCode: sendSMSCodeButton.rx.tap.asSignal(),
                smsCode: smsCode,
                verifyCode: verifySMSCodeButton.rx.tap.asSignal()
            )
        )

        output.loading.drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        output.type
            .drive(with: self, onNext: { (self, type) in
                self.titleLabel.text = type.title
                self.descriptionLabel.text = type.description
            })
        .disposed(by: disposeBag)

        output.validatedPhoneNumber
            .drive(with: self, onNext: { (self, result) in })
            .disposed(by: disposeBag)

        output.sendSMSCodeEnabled
            .drive(sendSMSCodeButton.ext.isEnabled)
            .disposed(by: disposeBag)

        output.isSMSCodeSent
            .drive(with: self, onNext: { (self, result) in
                if result == .request {
                    self.remainingTimer.startTimer()
                    self.sendSMSCodeButton.isHidden = true
                } else if result == .reRequest {
                    self.remainingTimer.resetTimer()
                }
            })
        .disposed(by: disposeBag)

        output.verifySMSCodeEnabled
            .drive(verifySMSCodeButton.ext.isEnabled)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Hierarchy
    
    private func configureHierarchy() {
        view.backgroundColor = .systemBackground

        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.spacing = 8.0
        [titleLabel, descriptionLabel]
            .forEach(titleStack.addArrangedSubview(_:))

        let userInfoStack = UIStackView()
        userInfoStack.axis = .vertical
        userInfoStack.spacing = 12
        [usernameTextField, phoneNumberTextField]
            .forEach(userInfoStack.addArrangedSubview(_:))

        let smsCodeStack = UIStackView()
        smsCodeStack.axis = .vertical
        [smsCodeLabel, smsCodeTextField, verifySMSCodeButton]
            .forEach(smsCodeStack.addArrangedSubview(_:))
        smsCodeStack.setCustomSpacing(8.0, after: smsCodeStack)
        smsCodeStack.setCustomSpacing(20, after: smsCodeTextField)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        [titleStack, userInfoStack, sendSMSCodeButton, smsCodeStack]
            .forEach(contentStack.addArrangedSubview(_:))
        contentStack.setCustomSpacing(40, after: titleStack)
        contentStack.setCustomSpacing(20, after: userInfoStack)
        contentStack.setCustomSpacing(12, after: sendSMSCodeButton)

        view.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let insets = CGFloat(20)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 58),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func configureNavItem() {}
}

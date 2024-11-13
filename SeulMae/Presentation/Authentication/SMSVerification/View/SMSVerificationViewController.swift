//
//  SMSVerificationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SMSVerificationViewController: BaseViewController {

    // MARK: - UI properties

    private let titleLabel = UILabel.ext.config(font: .pretendard(size: 24, weight: .semibold))
    private let descriptionLabel = UILabel.ext.config(font: .pretendard(size: 13, weight: .regular))
    private let usernameTextField = UITextField.ext.tf()
        .ext.backgroundColor("F2F5FF")
        .ext.placeholder("이름을 입력해주세요")
    private let phoneNumberTextField = UITextField.ext.tf()
        .ext.backgroundColor("F2F5FF")
        .ext.tel()
        .ext.placeholder("휴대폰 번호를 입력해주세요")
    private let sendSMSCodeButton = UIButton.ext.common(title: "인증번호 받기")

    private let smsCodeStack = UIStackView()
    private let smsCodeLabel = UILabel.ext.common("인증번호 입력", font: .pretendard(size: 14, weight: .regular))
    private let resendSMSCodeButton = UIButton.ext.small(title: "재전송")
        .ext.font(.pretendard(size: 14, weight: .semibold))
        .ext.size(width: 72, height: 32)
        .ext.config(textColor: .white, backgroundColor: .ext.hex("4C71F5"))

    private lazy var remainingTimer = RemainingTimer().then {
        $0.setRemainingTime(minutes: 3)
        $0.onFire = { [weak self] timer in
            self?.timeoutRelay.accept(true)
        }
    }
    private lazy var smsCodeTextField = UITextField.ext.tf()
        .ext.backgroundColor("F2F5FF")
        .ext.placeholder("인증번호 6자리 입력")

    private let verifySMSCodeButton = UIButton.ext.common(title: "인증번호 확인")

    private let adminButton = UIButton.ext.common(title: "다음")

    // MARK: - Dependencies

    private var viewModel: SMSVerificationViewModel!
    private var timeoutRelay = BehaviorRelay<Bool>(value: false)

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
                timeout: timeoutRelay.asDriver(),
                smsCode: smsCode,
                verifyCode: verifySMSCodeButton.rx.tap.asSignal(),
                pass: adminButton.rx.tap.asSignal()
            )
        )

        output.loading.drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        output.type
            .drive(with: self, onNext: { (self, type) in
                self.titleLabel.text = type.title
                self.descriptionLabel.text = type.description
                self.descriptionLabel.ext.highlight(font: .pretendard(size: 13, weight: .semibold), textColor: "4C71F5", words: "이름", "휴대폰 번호")
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
                if result.isSending {
                    self.smsCodeStack.isHidden = false
                    self.sendSMSCodeButton.isHidden = true
                    self.remainingTimer.isHidden = false
                    self.resendSMSCodeButton.isHidden = false
                }
                if result == .request {
                    self.remainingTimer.startTimer()
                    self.timeoutRelay.accept(false)
                } else if result == .reRequest {
                    self.remainingTimer.resetTimer()
                    self.timeoutRelay.accept(false)
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

        remainingTimer.isHidden = true
        resendSMSCodeButton.isHidden = true

        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.spacing = 8.0
        [titleLabel.ext.padding(leading: 12), descriptionLabel.ext.padding(leading: 12)]
            .forEach(titleStack.addArrangedSubview(_:))

        let userInfoStack = UIStackView()
        userInfoStack.axis = .vertical
        userInfoStack.spacing = 12
        [usernameTextField, phoneNumberTextField]
            .forEach(userInfoStack.addArrangedSubview(_:))
        
        smsCodeStack.isHidden = true
        smsCodeStack.axis = .vertical
        let padded = smsCodeLabel.ext.padding(leading: 12, top: 12)
        [padded, smsCodeTextField, verifySMSCodeButton]
            .forEach(smsCodeStack.addArrangedSubview(_:))
        smsCodeStack.setCustomSpacing(8.0, after: padded)
        smsCodeStack.setCustomSpacing(20, after: smsCodeTextField)

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        [titleStack, userInfoStack, sendSMSCodeButton, smsCodeStack]
            .forEach(contentStack.addArrangedSubview(_:))
        contentStack.setCustomSpacing(40, after: titleStack)
        contentStack.setCustomSpacing(20, after: userInfoStack)

        let views = [contentStack, remainingTimer, resendSMSCodeButton, adminButton]
        views.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let insets = CGFloat(20)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets),
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 58),
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            resendSMSCodeButton.trailingAnchor.constraint(equalTo: smsCodeTextField.trailingAnchor, constant: -8.0),
            resendSMSCodeButton.centerYAnchor.constraint(equalTo: smsCodeTextField.centerYAnchor),

            remainingTimer.trailingAnchor.constraint(equalTo: resendSMSCodeButton.leadingAnchor, constant: -8.0),
            remainingTimer.centerYAnchor.constraint(equalTo: resendSMSCodeButton.centerYAnchor),

            adminButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adminButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureNavItem() {}
}

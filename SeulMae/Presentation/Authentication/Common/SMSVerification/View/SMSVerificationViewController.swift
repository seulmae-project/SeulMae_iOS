//
//  SMSVerificationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import SnapKit

final class SMSVerificationViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: SMSVerificationViewModel) -> SMSVerificationViewController {
        let view = SMSVerificationViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Dependency
    
    private var viewModel: SMSVerificationViewModel!
    
    // MARK: - UI
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        return activity
    }()
    
    private let stepGuideLabel: UILabel = .title()
    
    private let accountIDLabel: UILabel = .callout(title: "아이디")
    
    private let accountIDTextField: UITextField = .common(placeholder: "아이디 입력")
    
    private let phoneNumberLabel: UILabel = .callout(title: "휴대폰 번호")
    
    private let phoneNumberTextField: UITextField = {
        let tf = UITextField.common(placeholder: "휴대폰 번호 입력", padding: 16)
        tf.textContentType = .telephoneNumber
        tf.keyboardType = .phonePad
        return tf
    }()
    
    private let smsCodeLabel: UILabel = .callout(title: "인증번호")
    
    private let smsCodeTextField: UITextField = .common(placeholder: "인증번호 6자리 입력")
    
    private lazy var remainingTimer: RemainingTimer = {
        let timer = RemainingTimer()
        timer.setRemainingTime(minutes: 3)
        timer.onFire = { [weak sendSMSCodeButton] timer in
            sendSMSCodeButton?.setTitle("인증번호 재전송", for: .normal)
        }
        return timer
    }()
    
    private let secondSMSCodeLabel: UILabel = .footnote(title:  "인증번호 재전송은 3회까지만 가능합니다")
    private let sendSMSCodeButton: UIButton = .common(title: "인증번호 전송", cornerRadius: 16)

    private let verifySMSCodeButton: UIButton = .common(title: "인증번호 확인", cornerRadius: 16)

    private let nextStepButton: UIButton = .common(title: "다음으로", isEnabled: false)
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        // Handle Background Tap
        let tapBackground = UITapGestureRecognizer()
        Task {
            for await tap in tapBackground.rx.event.asSignal().values {
                view.endEditing(true)
            }
        }
        view.addGestureRecognizer(tapBackground)
        
        // Handle TextField Editing State
        let phoneNumberEditing = phoneNumberTextField.rx
            .editing
            .asDriver()
            .distinctUntilChanged()
        
        Task {
            for await editing in phoneNumberEditing.values {
                phoneNumberTextField.ext.setEditing(editing)
            }
        }
        
        let smsCodeEditing = smsCodeTextField.rx
            .editing
            .asDriver()
            .distinctUntilChanged()
        
        Task {
            for await editing in smsCodeEditing.values {
                smsCodeTextField.ext.setEditing(editing)
            }
        }
        
        //  Handle TextField Max Length
        let phoneNumMaxLength = 11
        let phoneNumber = phoneNumberTextField.rx
            .text
            .orEmpty
            .map { $0.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) }
            .map { String($0.prefix(phoneNumMaxLength)) }
            .asDriver()
        
        Task {
            for await phoneNumber in phoneNumber.values {
                phoneNumberTextField.text = applyPhoneNumberFormat(text: phoneNumber)
            }
        }
        
        func applyPhoneNumberFormat(text: String) -> String {
            let numbers = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            var formatted = ""
            for (index, num) in numbers.enumerated() {
                if index == 3 || index == 7 {
                    formatted.append("-")
                }
                formatted.append(num)
            }
            // Swift.print("text: \(text), formatted: \(formatted)")
            return formatted
        }
        
        let codeMaxLength = 6
        let code = smsCodeTextField.rx
            .text
            .orEmpty
            .map { $0.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) }
            .map { String($0.prefix(codeMaxLength)) }
            .asDriver()
        
        Task {
            for await code in code.values {
                smsCodeTextField.text = code
            }
        }
        
        // Handle View Model Output
        let output = viewModel.transform(
            .init(
                phoneNumber: phoneNumber,
                code: code,
                sendSMSCode: sendSMSCodeButton.rx.tap.asSignal(),
                verifyCode: verifySMSCodeButton.rx.tap.asSignal(),
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        // Handle View Controller Type
        Task {
            for await item in output.item.values {
                stepGuideLabel.text = item.stepGuide
                navigationItem.title = item.navItemTitle
                accountIDTextField.isHidden = item.isHiddenAccountIDField
                accountIDLabel.isHidden = item.isHiddenAccountIDField
            }
        }
        
        // Handle Loading
        Task {
            for await isLoading in output.isLoading.values {
                loadingIndicator.ext.isAnimating(isLoading)
            }
        }
        
        // Handle Validated Input
        Task {
            for await _ in output.validatedPhoneNumber.values {
                // Swift.print("Phone Number: \(phoneNum)")
            }
        }
        
        Task {
            for await _ in output.verifiedCode.values {
                // Swift.print("SMS Code: \(code)")
            }
        }
        
        // Handle Button Enabled
        Task {
            for await enabled in output.sendSMSCodeEnabled.values {
                // Swift.print("Send SMS Code Button Enabled: \(enabled)")
                sendSMSCodeButton.ext.setEnabled(enabled)
            }
        }
        
        Task {
            for await enabled in output.verifySMSCodeEnabled.values {
                // Swift.print("Verify SMS Code Button Enabled: \(enabled)")
                verifySMSCodeButton.ext.setEnabled(enabled)
            }
        }
        
        Task {
            for await enabled in output.nextStepEnabled.values {
                // Swift.print("Next Step Button Enabled: \(enabled)")
                nextStepButton.ext.setEnabled(enabled)
            }
        }
        
        // Handle Remaining Timer
        Task {
            for await state in output.isSent.values {
                if state == .request {
                    remainingTimer.startTimer()
                    sendSMSCodeButton.setTitle("인증번호 재전송", for: .normal)
                } else if state == .reRequest {
                    remainingTimer.resetTimer()
                    sendSMSCodeButton.backgroundColor = UIColor(hexCode: "F0F0F0")
                }
            }
        }
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .black
        
        /// - Tag: Account ID
        let accountIDVStack = UIStackView(arrangedSubviews: [
            accountIDLabel, accountIDTextField
        ])
        accountIDVStack.axis = .vertical
        accountIDVStack.spacing = 8.0
        
        /// - Tag: Phone Number
        let phoneNumberHStack = UIStackView(arrangedSubviews: [
            phoneNumberTextField, sendSMSCodeButton
        ])
        phoneNumberHStack.spacing = 8.0
        phoneNumberHStack.distribution = .fillProportionally
        
        let phoneNumberVStack = UIStackView(arrangedSubviews: [
            phoneNumberLabel, phoneNumberHStack])
        phoneNumberVStack.axis = .vertical
        phoneNumberVStack.spacing = 8.0
        
        /// - Tag: Verification Code
        let codeHStack = UIStackView(arrangedSubviews: [
            smsCodeTextField, verifySMSCodeButton
        ])
        codeHStack.spacing = 8.0
        codeHStack.distribution = .fillProportionally
        
        let codeVStack = UIStackView(arrangedSubviews: [
            smsCodeLabel, codeHStack, secondSMSCodeLabel
        ])
        codeVStack.axis = .vertical
        codeVStack.spacing = 8.0
        
        /// - Tag: Input Field
        let inputVStack = UIStackView(arrangedSubviews: [
            accountIDVStack, phoneNumberVStack, codeVStack
        ])
        inputVStack.axis = .vertical
        inputVStack.spacing = 16

        /// - Tag: Hierarchy
        let subViews: [UIView] = [
            stepGuideLabel,
            inputVStack,
            remainingTimer,
            nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        stepGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(24)
            make.centerX.equalToSuperview()
        }
        
        inputVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(stepGuideLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
        }
        
        [sendSMSCodeButton, verifySMSCodeButton].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(127)
                make.height.equalTo(48)
            }
        }
        
        remainingTimer.snp.makeConstraints { make in
            make.trailing.equalTo(smsCodeTextField.snp.trailing).inset(16)
            make.centerY.equalTo(smsCodeTextField.snp.centerY)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - UITextField Extension

extension UITextField: Extended {}
extension Extension where ExtendedType == UITextField {
    func setEditing(_ isEditing: Bool) {
        if isEditing {
            type.layer.borderColor = UIColor.graphite.cgColor
            type.layer.borderWidth = 1.0
        } else {
            type.layer.borderColor = UIColor.textFieldBorder.cgColor
            type.layer.borderWidth = 1.0
        }
    }
}

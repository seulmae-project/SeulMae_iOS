//
//  SMSValidationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import SnapKit

final class SMSValidationViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: SMSValidationViewModel) -> SMSValidationViewController {
        let view = SMSValidationViewController()
        view.viewModel = viewModel
        return view
    }
    
    // MARK: - Dependency
    
    private var viewModel: SMSValidationViewModel!
    
    // MARK: - UI
    
    private let stepGuideLabel: UILabel = .title()
    
    private let accountIDFieldGuideLabel: UILabel = .callout(title: "아이디")
    private let accountIDTextField: UITextField = .common(placeholder: "아이디 입력")
    
    private let phoneNumberFieldGuideLabel: UILabel = .callout(title: "휴대폰 번호")
    private let phoneNumberTextField: UITextField = .tel(placeholder: "휴대폰번호 입력")

    private let authCodeFieldGuideLabel: UILabel = .callout(title: "인증번호")
    private let authCodeTextField: UITextField = .common(placeholder: "인증번호 6자리 입력")
    
    private let remainingTimeLabel: RemainingTimeLabel = {
        let label = RemainingTimeLabel()
        label.setRemainingTime(minutes: 3)
        return label
    }()
    
    private let secondAuthCodeFieldGuideLabel: UILabel = .footnote(title:  "인증번호 재전송은 3회까지만 가능합니다")
    private let sendSMSCodeButton: UIButton = .common(title: "인증번호 받기", cornerRadius: 16)
    
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
        let sendSMSCode = sendSMSCodeButton.rx.tap.asSignal()

        let output = viewModel.transform(
            .init(
                phoneNumber: phoneNumberTextField.rx.text.orEmpty.asDriver(),
                code: authCodeTextField.rx.text.orEmpty.asDriver(),
                sendSMSCode: sendSMSCode,
                verifyCode: verifySMSCodeButton.rx.tap.asSignal(),
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await item in output.item.values {
                applyItem(item)
            }
        }
        
        let isResponder = phoneNumberTextField.rx.controlEvent([.editingDidBegin, .editingDidEnd])
            .map { [weak phoneNumberTextField] in
                return phoneNumberTextField?.isFirstResponder ?? false
            }
            .distinctUntilChanged()
            .asSignal()
        
        Task {
            for await isResponder in isResponder.values {
                if isResponder {
                    phoneNumberTextField.layer.borderColor = UIColor.graphite.cgColor
                    phoneNumberTextField.layer.borderWidth = 2.0
                } else {
                    phoneNumberTextField.layer.borderColor = UIColor.textFieldBorder.cgColor
                    phoneNumberTextField.layer.borderWidth = 1.0
                }
            }
        }
        
        
        Task {
            for await _ in output.validatedPhoneNumber.values {
                
            }
        }
        
        Task {
            for await enabled in output.sendSMSCodeEnabled.values {
                sendSMSCodeButton.ext.setEnabled(enabled)
            }
        }
        
        Task {
            for await enabled in output.verifySMSCodeEnabled.values {
                print("codeVerificationEnabled: \(enabled)")
                verifySMSCodeButton.ext.setEnabled(enabled)
            }
        }
        
        Task {
            for await _ in output.verifiedCode.values {
                
            }
        }
        
        Task {
            for await enabled in output.nextStepEnabled.values {
                nextStepButton.ext.setEnabled(enabled)
            }
        }
        
        Task {
            for await _ in sendSMSCode.values {
                // TODO: 00:00이 되면 인증번호 받기로 바뀌고 03:00 으로 변경해야 함
                // callback 사용
                // 한번만 텍스트 변경되도록 변경 -> label 과 합쳐
                if !(remainingTimeLabel.text == "00:00") {
                    sendSMSCodeButton.setTitle("인증번호 재전송", for: .normal)
                    sendSMSCodeButton.backgroundColor = UIColor(hexCode: "F0F0F0")
                    sendSMSCodeButton.setTitleColor(UIColor(hexCode: "676768"), for: .normal)
                }
            }
        }
        
        Task {
            for await state in output.isSended.values {
                if state == .request {
                    remainingTimeLabel.startTimer()
                    // 이게 bool값일 이유 > 재전송을 구분해야함
                } else if state == .reRequest {
                    
                }
            }
        }
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        /// - Tag: Account ID
        let accountIDVStack = UIStackView(arrangedSubviews: [
            accountIDFieldGuideLabel, accountIDTextField
        ])
        accountIDVStack.axis = .vertical

        /// - Tag: Phone Number
        let phoneNumberHStack = UIStackView(arrangedSubviews: [
            phoneNumberTextField, sendSMSCodeButton
        ])
        phoneNumberHStack.spacing = 8.0
        phoneNumberHStack.distribution = .fillProportionally
        
        let phoneNumberVStack = UIStackView(arrangedSubviews: [
            phoneNumberFieldGuideLabel, phoneNumberHStack])
        phoneNumberVStack.axis = .vertical
        
        /// - Tag: Verification Code
        let codeHStack = UIStackView(arrangedSubviews: [
            authCodeTextField, verifySMSCodeButton
        ])
        codeHStack.spacing = 8.0
        codeHStack.distribution = .fillProportionally
        
        let codeVStack = UIStackView(arrangedSubviews: [
            authCodeFieldGuideLabel, codeHStack, secondAuthCodeFieldGuideLabel
        ])
        
        codeVStack.axis = .vertical
        codeVStack.setCustomSpacing(8.0, after: codeHStack)
        
        /// - Tag: Input
        
        let inputVStack = UIStackView(arrangedSubviews: [
            accountIDVStack, phoneNumberVStack, codeVStack
        ])
        inputVStack.axis = .vertical
        inputVStack.spacing = 16

        /// - Tag: Hierarchy
        
        let subViews: [UIView] = [
            stepGuideLabel,
            inputVStack,
            remainingTimeLabel,
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
        
        sendSMSCodeButton.snp.makeConstraints { make in
            make.width.equalTo(127)
            make.height.equalTo(48)
        }
        
        verifySMSCodeButton.snp.makeConstraints { make in
            make.width.equalTo(127)
            make.height.equalTo(48)
        }
        
        remainingTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(authCodeTextField.snp.trailing).inset(16)
            make.centerY.equalTo(authCodeTextField.snp.centerY)
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
    
    private func applyItem(_ item: SMSValidationItem) {
        stepGuideLabel.text = item.stepGuide
        navigationItem.title = item.navItemTitle
        accountIDTextField.isHidden = item.isHiddenAccountIDField
        accountIDFieldGuideLabel.isHidden = item.isHiddenAccountIDField
    }
}

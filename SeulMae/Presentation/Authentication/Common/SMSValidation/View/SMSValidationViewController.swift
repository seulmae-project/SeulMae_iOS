//
//  PhoneVerificationViewController.swift
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
    
    enum Text {
        static let accountIDFieldGuide = "아이디"
        static let accountIDTextFieldGuide = "아이디 입력"
        static let phoneNumberFieldGuide = "휴대폰 번호"
        static let phoneNumberTextFieldGuide = "휴대폰번호 입력"
        static let authCodeFieldGuide = "인증번호"
        static let authCodeTextFieldGuide = "인증번호 6자리 입력"
        static let remainingTime = "03:00"
        static let secondAuthCodeFieldGuide = "인증번호 재전송은 3회까지만 가능합니다"
        static let sendAuthCode = "인증번호 받기"
        static let verifyCode = "인증번호 확인"
        static let resendAuthCode = "인증번호 재전송"
        static let nextStep = "다음으로"
    }
    
    // MARK: - Dependency
    
    private var viewModel: SMSValidationViewModel!
    
    // MARK: - UI
    
    private let stepGuideLabel: UILabel = .title()
    
    private let accountIDFieldGuideLabel: UILabel = .callout(title: Text.accountIDFieldGuide)
    private let accountIDTextField: UITextField = .common(placeholder: Text.accountIDTextFieldGuide)
    
    private let phoneNumberFieldGuideLabel: UILabel = .callout(title: Text.phoneNumberFieldGuide)
    private let phoneNumberTextField: UITextField = .tel(placeholder: Text.phoneNumberTextFieldGuide)
    
    private let authCodeFieldGuideLabel: UILabel = .callout(title: Text.authCodeFieldGuide)
    private let authCodeTextField: UITextField = .common(placeholder: Text.authCodeTextFieldGuide)
    
    private let remainingTimeLabel: RemainingTimeLabel = {
        let label = RemainingTimeLabel()
        label.setRemainingTime(minutes: 3)
        return label
    }()
    
    private let secondAuthCodeFieldGuideLabel: UILabel = .footnote(title: Text.secondAuthCodeFieldGuide)
    private let smsValidationButton: UIButton = .common(title: Text.sendAuthCode, cornerRadius: 16)
    
    private let codeVerificationButton: UIButton = .common(title: Text.verifyCode, cornerRadius: 16)

    private let nextStepButton: UIButton = .common(title: Text.nextStep, isEnabled: false)
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        let validateSMS = smsValidationButton.rx.tap.asSignal()

        let output = viewModel.transform(
            .init(
                phoneNumber: phoneNumberTextField.rx.text.orEmpty.asDriver(),
                code: authCodeTextField.rx.text.orEmpty.asDriver(),
                validateSMS: validateSMS,
                verifyCode: codeVerificationButton.rx.tap.asSignal(),
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await item in output.item.values {
                applyItem(item)
            }
        }
        
        Task {
            for await enabled in output.smsValidationEnabled.values {
                print("smsValidationEnabled: \(enabled)")
                smsValidationButton.ext.setEnabled(enabled)
            }
        }
        
//        Task {
//            for await _ in output.validatedSMS.values {
//                
//            }
//        }
        
        Task {
            for await enabled in output.codeVerificationEnabled.values {
                print("codeVerificationEnabled: \(enabled)")
                codeVerificationButton.ext.setEnabled(enabled)
            }
        }
        
//        Task {
//            for await _ in output.verifiedCode.values {
//                
//            }
//        }
        
        Task {
            for await enabled in output.nextStepEnabled.values {
                nextStepButton.ext.setEnabled(enabled)
            }
        }
        
        Task {
            for await _ in validateSMS.values {
                // TODO: 00:00이 되면 인증번호 받기로 바뀌고 03:00 으로 변경해야 함
                // callback 사용
                // 한번만 텍스트 변경되도록 변경 -> label 과 합쳐
                if !(remainingTimeLabel.text == "00:00") {
                    smsValidationButton.setTitle("인증번호 재전송", for: .normal)
                    smsValidationButton.backgroundColor = UIColor(hexCode: "F0F0F0")
                    smsValidationButton.setTitleColor(UIColor(hexCode: "676768"), for: .normal)
                }
                
                enum RequestButtonStatus {
                    case request
                    case reRequest
                }
            }
        }
        
        Task {
            for await _ in output.validatedSMS.values {
                remainingTimeLabel.startTimer()
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
            phoneNumberTextField, smsValidationButton
        ])
        phoneNumberHStack.spacing = 8.0
        phoneNumberHStack.distribution = .fillProportionally
        
        let phoneNumberVStack = UIStackView(arrangedSubviews: [
            phoneNumberFieldGuideLabel, phoneNumberHStack])
        phoneNumberVStack.axis = .vertical
        
        /// - Tag: Verification Code
        let codeHStack = UIStackView(arrangedSubviews: [
            authCodeTextField, codeVerificationButton
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
        
        smsValidationButton.snp.makeConstraints { make in
            make.width.equalTo(127)
            make.height.equalTo(48)
        }
        
        codeVerificationButton.snp.makeConstraints { make in
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

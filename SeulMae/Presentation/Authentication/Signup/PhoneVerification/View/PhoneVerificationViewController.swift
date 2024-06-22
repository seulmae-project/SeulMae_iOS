//
//  PhoneVerificationViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import SnapKit

final class PhoneVerificationViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: PhoneVerificationViewModel) -> PhoneVerificationViewController {
        let view = PhoneVerificationViewController()
        view.viewModel = viewModel
        return view
    }
    
    enum Text {
        static let stepGuide = "정보 확인을 위해\n휴대폰번호를 입력해주세요"
        static let phoneNumberFieldGuide = "휴대폰 번호"
        static let phoneNumberTextFieldGuide = "휴대폰번호 입력"
        static let authCodeFieldGuide = "인증번호"
        static let authCodeTextFieldGuide = "인증번호 6자리 입력"
        static let remainingTime = "03:00"
        static let secondAuthCodeFieldGuide = "인증번호 재전송은 3회까지만 가능합니다"
        static let sendAuthCode = "인증번호 받기"
        static let verifyCode = "인증번호 확인"
        static let reSendAuthCode = "인증번호 재전송"
        static let nextStep = "다음으로"
    }
    
    // MARK: - Dependency
    
    private var viewModel: PhoneVerificationViewModel!
    
    // MARK: - UI
    
    private let stepGuideLabel: UILabel = .title(title: Text.stepGuide)
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
    private let sendAuthCodeButton: UIButton = .common(title: Text.sendAuthCode, cornerRadius: 16)
    
    private let verifyCodeButton: UIButton = .common(title: Text.verifyCode, cornerRadius: 16)

    private let nextStepButton: UIButton = .common(title: Text.nextStep, isEnabled: false)
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavItem()
        configureHierarchy()
        bindInternalSubviews()
    }
    
    // MARK: - Data Binding
    
    private func bindInternalSubviews() {
        let sendAuth = sendAuthCodeButton.rx.tap.asSignal()

        let output = viewModel.transform(
            .init(
                phoneNumber: phoneNumberTextField.rx.text.orEmpty.asDriver(),
                authCode: authCodeTextField.rx.text.orEmpty.asDriver(),
                sendAuth: sendAuth,
                verifyCode: verifyCodeButton.rx.tap.asSignal(),
                nextStep: nextStepButton.rx.tap.asSignal()
            )
        )
        
        Task {
            for await _ in sendAuth.values {
                // TODO: 00:00이 되면 인증번호 받기로 바뀌고 03:00 으로 변경해야 함
                // callback 사용
                // 한번만 텍스트 변경되도록 변경 -> label 과 합쳐
                if !(remainingTimeLabel.text == "00:00") {
                    sendAuthCodeButton.setTitle("인증번호 재전송", for: .normal)
                    sendAuthCodeButton.backgroundColor = UIColor(hexCode: "F0F0F0")
                    sendAuthCodeButton.setTitleColor(UIColor(hexCode: "676768"), for: .normal)
                }
                
                enum RequestButtonStatus {
                    case request
                    case reRequest
                }
            }
        }
        
        Task {
            for await _ in output.requested.values {
                remainingTimeLabel.startTimer()
            }
        }
        
        Task {
            for await verified in output.verified.values {
                nextStepButton.isEnabled = verified
                nextStepButton.alpha = verified ? 1.0 : 0.5
                // TODO: enabled 에 따라 디자인 변경
            }
        }
    }
    
    // MARK: - Nav Item
    
    private func configureNavItem() {
        
    }
    
    // MARK: - Hierarchy

    private func configureHierarchy() {
        view.backgroundColor = .systemBackground
        
        let phoneNumberFeildHStack = UIStackView(arrangedSubviews: [
            phoneNumberTextField, sendAuthCodeButton
        ])
        phoneNumberFeildHStack.spacing = 8.0
        phoneNumberFeildHStack.distribution = .fillProportionally
        
        let phoneNumberFieldVStack = UIStackView(arrangedSubviews: [
            phoneNumberFieldGuideLabel, phoneNumberFeildHStack])
        phoneNumberFieldVStack.axis = .vertical
        
        let authCodeFieldHStack = UIStackView(arrangedSubviews: [
            authCodeTextField, verifyCodeButton
        ])
        authCodeFieldHStack.spacing = 8.0
        authCodeFieldHStack.distribution = .fillProportionally
        
        let authCodeFieldVStack = UIStackView(arrangedSubviews: [
            authCodeFieldGuideLabel, authCodeFieldHStack, secondAuthCodeFieldGuideLabel
        ])
        
        authCodeFieldVStack.axis = .vertical
        authCodeFieldVStack.setCustomSpacing(8.0, after: authCodeFieldHStack)
        
        let subViews: [UIView] = [
            stepGuideLabel, phoneNumberFieldVStack, authCodeFieldVStack, remainingTimeLabel, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        stepGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(24)
            make.centerX.equalToSuperview()
        }
        
        phoneNumberFieldVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(stepGuideLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        authCodeFieldHStack.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        authCodeFieldVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(phoneNumberFieldVStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
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
}

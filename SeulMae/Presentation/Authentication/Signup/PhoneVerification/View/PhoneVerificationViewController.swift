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
        static let reSendAuthCode = "인증번호 재전송"
        static let nextStep = "다음으로"
    }
    
    // MARK: - Dependency
    
    private var viewModel: PhoneVerificationViewModel!
    
    // MARK: - UI
    
    private let stepGuideLabel: UILabel = .title(title: Text.stepGuide)
    private let phoneNumberFieldGuideLabel: UILabel = .callout(title: Text.phoneNumberFieldGuide)
    private let phoneNumberTextField: UITextField = .common(placeholder: Text.phoneNumberTextFieldGuide)
    private let authCodeFieldGuideLabel: UILabel = .callout(title: Text.authCodeFieldGuide)
    private let authCodeTextField: UITextField = .common(placeholder: Text.authCodeTextFieldGuide)
    private let remainingTimeLabel: UILabel = .footnote(title: Text.remainingTime, color: .red)
    private let secondAuthCodeFieldGuideLabel: UILabel = .footnote(title: Text.secondAuthCodeFieldGuide)
    private let sendAuthCodeButton: UIButton = .common(title: Text.sendAuthCode, cornerRadius: 16)
    private let nextStepButton: UIButton = .common(title: Text.nextStep)
    
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
        let phoneNumberFieldStack = UIStackView(arrangedSubviews: [
            phoneNumberFieldGuideLabel, phoneNumberTextField])
        phoneNumberFieldStack.axis = .vertical
        
        let authCodeFieldHStack = UIStackView(arrangedSubviews: [
            authCodeTextField, sendAuthCodeButton
        ])
        authCodeFieldHStack.spacing = 8.0
        authCodeFieldHStack.distribution = .fillProportionally
        
        let authCodeFieldVStack = UIStackView(arrangedSubviews: [
            authCodeFieldGuideLabel, authCodeFieldHStack, secondAuthCodeFieldGuideLabel
        ])
        authCodeFieldVStack.axis = .vertical
        authCodeFieldVStack.setCustomSpacing(8.0, after: authCodeFieldHStack)
        
        let subViews: [UIView] = [
            stepGuideLabel, phoneNumberFieldStack, authCodeFieldVStack, remainingTimeLabel, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        stepGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(24)
            make.centerX.equalToSuperview()
        }
        
        phoneNumberFieldStack.snp.makeConstraints { make in
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
            make.top.equalTo(phoneNumberFieldStack.snp.bottom).offset(16)
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

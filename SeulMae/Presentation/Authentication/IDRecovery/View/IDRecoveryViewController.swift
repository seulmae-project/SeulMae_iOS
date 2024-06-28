//
//  IDRecoveryViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import UIKit

final class IDRecoveryViewController: UIViewController {
    
    // MARK: - Flow
    
    static func create(viewModel: IDRecoveryViewModel) -> IDRecoveryViewController {
        let view = IDRecoveryViewController()
        view.viewModel = viewModel
        return view
    }
        
    enum Text {
        static let stepGuide = "이메일 주소를\n확인해 주시길 바랍니다"
        static let emailFieldGuide = "이메일 주소"
        static let findPassword = "비밀번호를 잃어버리셨나요?"
        static let nextStep = "로그인 하기"
    }
    
    // MARK: - Dependency
    
    private var viewModel: IDRecoveryViewModel!
    
    // MARK: - UI
    
    private let stepGuideLabel: UILabel = .title(title: Text.stepGuide)
    private let phoneNumberFieldGuideLabel: UILabel = .callout(title: Text.emailFieldGuide)
    private let phoneNumberTextField: UITextField = .common(placeholder: Text.findPassword)
    // private let authCodeFieldGuideLabel: UILabel = .callout(title: Text.authCodeFieldGuide)
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
//        let phoneNumberFieldStack = UIStackView(arrangedSubviews: [
//            phoneNumberFieldGuideLabel, phoneNumberTextField])
//        phoneNumberFieldStack.axis = .vertical
//        
//        let subViews: [UIView] = [
//            stepGuideLabel, phoneNumberFieldStack, authCodeFieldVStack, remainingTimeLabel, nextStepButton
//        ]
//        subViews.forEach(view.addSubview)
//        
//        stepGuideLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(20)
//            make.top.equalTo(view.snp_topMargin).inset(24)
//            make.centerX.equalToSuperview()
//        }
//        
//        phoneNumberFieldStack.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(20)
//            make.top.equalTo(stepGuideLabel.snp.bottom).offset(52)
//            make.centerX.equalToSuperview()
//        }
//        
//        phoneNumberTextField.snp.makeConstraints { make in
//            make.height.equalTo(48)
//        }
//        
//        authCodeFieldHStack.snp.makeConstraints { make in
//            make.height.equalTo(48)
//        }
//        
//        authCodeFieldVStack.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(20)
//            make.top.equalTo(phoneNumberFieldStack.snp.bottom).offset(16)
//            make.centerX.equalToSuperview()
//        }
//        
//        remainingTimeLabel.snp.makeConstraints { make in
//            make.trailing.equalTo(authCodeTextField.snp.trailing).inset(16)
//            make.centerY.equalTo(authCodeTextField.snp.centerY)
//        }
//        
//        nextStepButton.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(20)
//            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
//            make.height.equalTo(56)
//            make.centerX.equalToSuperview()
//        }
    }
}

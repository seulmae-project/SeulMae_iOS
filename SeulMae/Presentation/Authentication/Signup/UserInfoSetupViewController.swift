//
//  UserInfoSetupViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit
import SnapKit

extension UIViewController {
    static func createTitleGuideLabel(title: String) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        return guideLabel
    }
    
    static func createTextFiledGuideLabel(title: String) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.font = .systemFont(ofSize: 16)
        return guideLabel
    }
    
    static func createSecondTextFieldGuideLabel(title: String) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.font = .systemFont(ofSize: 14)
        return guideLabel
    }
    
    static func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        
        return textField
    }
    
    static func createButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8.0
        return button
    }
}

final class UserInfoSetupViewController: UIViewController {
    
    enum GuideText {
        static let stepGuide = "본인 확인을 위해\n정보를 입력해주세요"
        static let nameFieldGuide = "이름"
        static let nameTextFieldGuide = "이름 입력"
        static let ssnFieldGuide = "주민등록번호"
        static let frontSSNTextFeildGuide = "생년월일"
        static let backSSNTextFeildGuide = "0●●●●●●"
        static let nextStepButtonTitle = "다음으로"
    }
    
    private var stepGuideLabel: UILabel!
    private var nameFieldGuideLabel: UILabel!
    private var nameTextField: UITextField!
    private var ssnFieldGuideLabel: UILabel!
    private var frontSSNTextField: UITextField!
    private var backSSNTextField: UITextField!
    private var nextStepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
    }
    
    private func configureHierarchy() {
        stepGuideLabel = Self.createTitleGuideLabel(title: GuideText.stepGuide)
        nameFieldGuideLabel = Self.createTextFiledGuideLabel(title: GuideText.nameFieldGuide)
        nameTextField = Self.createTextField(placeholder: GuideText.nameTextFieldGuide)
        ssnFieldGuideLabel = Self.createTextFiledGuideLabel(title: GuideText.ssnFieldGuide)
        frontSSNTextField = Self.createTextField(placeholder: GuideText.frontSSNTextFeildGuide)
        backSSNTextField = Self.createTextField(placeholder: GuideText.backSSNTextFeildGuide)
        nextStepButton = Self.createButton(title: GuideText.nextStepButtonTitle)
        
        let nameFieldStack = UIStackView(arrangedSubviews: [nameFieldGuideLabel, nameTextField])
        let ssnFieldHStack = UIStackView(arrangedSubviews: [frontSSNTextField, backSSNTextField])
        let ssnFeildVStack = UIStackView(arrangedSubviews: [ssnFieldGuideLabel, ssnFieldHStack])
        ssnFeildVStack.axis = .vertical
        
        let subViews: [UIView] = [
            stepGuideLabel, nameFieldStack, ssnFeildVStack, nextStepButton
        ]
        subViews.forEach(view.addSubview)
        
        stepGuideLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.snp_topMargin).inset(24)
            make.centerX.equalToSuperview()
        }
        
        nameFieldStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(stepGuideLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
        }
        
        ssnFeildVStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(nameFieldStack.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        nextStepButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp_bottomMargin).inset(24)
            make.height.equalTo(56)
            make.centerX.equalToSuperview()
        }
    }
}

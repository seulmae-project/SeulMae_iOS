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
        guideLabel.font = .systemFont(ofSize: 24)
        return guideLabel
    }
    
    static func createTextFiledGuideLabel(title: String) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.font = .systemFont(ofSize: 14)
        return guideLabel
    }
    
    static func createSecondTextFieldGuideLabel(title: String) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.font = .systemFont(ofSize: 12)
        return guideLabel
    }
    
    static func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        
        return textField
    }
    
    static func createButton(placeholder: String) -> UIButton {
        let button = UIButton()
        
        return button
    }
}

final class UserInfoSetupViewController: UIViewController {
    
    enum GuideText {
        static let stepGuide = ""
        static let nameFieldGuide = ""
        static let nameTextFieldGuide = ""
        static let ssnFieldGuide = ""
        static let frontSSNTextFeildGuide = ""
        static let backSSNTextFeildGuide = ""
        static let secondSSNFeildGuide = ""
        static let nextStepButtonTitle = ""
    }
    
    private var stepGuideLabel: UILabel!
    private var nameFieldGuideLabel: UILabel!
    private var nameTextField: UITextField!
    private var ssnFieldGuideLabel: UILabel!
    private var frontSSNTextField: UITextField!
    private var backSSNTextField: UITextField!
    private var secondSSNFieldGudieLabel: UILabel!
    private var nextStepButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
    }
    
    private func configureHierarchy() {
        self.stepGuideLabel = Self.createTitleGuideLabel(title: GuideText.stepGuide)
        self.nameFieldGuideLabel = Self.createTextFiledGuideLabel(title: GuideText.nameFieldGuide)
        self.nameTextField = Self.createTextField(placeholder: GuideText.nameTextFieldGuide)
        self.ssnFieldGuideLabel = Self.createTextFiledGuideLabel(title: GuideText.ssnFieldGuide)
        self.frontSSNTextField = Self.createTextField(placeholder: GuideText.frontSSNTextFeildGuide)
        self.backSSNTextField = Self.createTextField(placeholder: GuideText.backSSNTextFeildGuide)
        self.secondSSNFieldGudieLabel = Self.createSecondTextFieldGuideLabel(title: GuideText.secondSSNFeildGuide)
        self.nextStepButton = Self.createButton(placeholder: GuideText.nextStepButtonTitle)
    }
}

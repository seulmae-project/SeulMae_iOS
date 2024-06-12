//
//  UserInfoSetupViewController.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

extension UILabel {
    static func title(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        return label
    }
    
    static func callout(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16)
        return label
    }
    
    static func footnote(
        title: String,
        color: UIColor = .secondaryLabel
    ) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = .systemFont(ofSize: 14)
        return label
    }
}

extension UIViewController {
    
    static func createTitleGuideLabel(title: String) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.numberOfLines = 2
        guideLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        return guideLabel
    }
    
    static func createTextFiledGuideLabel(title: String) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.font = .systemFont(ofSize: 16)
        return guideLabel
    }
    
    static func createSecondTextFieldGuideLabel(title: String, color: UIColor = .secondaryLabel) -> UILabel {
        let guideLabel = UILabel()
        guideLabel.text = title
        guideLabel.textColor = color
        guideLabel.font = .systemFont(ofSize: 14)
        return guideLabel
    }
    
    static func createTextField(placeholder: String, padding: CGFloat = 16) -> UITextField {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        let attrString = NSAttributedString(
            string: placeholder,
            attributes: [.font: UIFont.systemFont(ofSize: 14)])
        textField.attributedPlaceholder = attrString
        textField.layer.cornerRadius = 16
        textField.layer.cornerCurve = .continuous
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor(hexCode: "D0D0D0").cgColor
        return textField
    }
    
    static func createButton(title: String, cornerRadius: CGFloat = 8.0) -> UIButton {
        let button = UIButton()
        button.isEnabled = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(hexCode: "D0D0D0") // UIColor(hexCode: "0086FF")
        button.layer.cornerRadius = cornerRadius
        button.layer.cornerCurve = .continuous
        return button
    }
}

//
//  UIKit+.swift
//  SeulMae
//
//  Created by 조기열 on 6/10/24.
//

import UIKit

// MARK: - UIImageView

extension UIImageView {
    static func common(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }
}

// MARK: - UILabel

extension UILabel {
    static func section(title: String = "") -> UILabel {
        let l = UILabel()
        l.text = title
        l.font = .systemFont(ofSize: 20, weight: .semibold)
        return l
    }
    
    static func title(title: String = "") -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        return label
    }
    
    static func callout(title: String = "") -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 16)
        return label
    }
    
    static func footnote(title: String = "", color: UIColor = .secondaryLabel) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = .systemFont(ofSize: 14)
        return label
    }
}

// MARK: - UIButton

extension UIButton {
    static func common(title: String = "", cornerRadius: CGFloat = 8.0, isEnabled: Bool = true) -> UIButton {
        let button = UIButton()
        button.isEnabled = isEnabled
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .primary
        button.layer.cornerRadius = cornerRadius
        button.layer.cornerCurve = .continuous
        return button
    }
    
    static func callout(title: String, isEnabled: Bool = true) -> UIButton {
        let button = UIButton()
        button.isEnabled = isEnabled
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hexCode: "676768"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        return button
    }
}

// MARK: - UITextField

extension UITextField {
    static func common(placeholder: String, padding: CGFloat = 16) -> UITextField {
        let tf = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 0))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        let attrString = NSAttributedString(
            string: placeholder,
            attributes: [.font: UIFont.systemFont(ofSize: 14)])
        tf.attributedPlaceholder = attrString
        tf.layer.cornerRadius = 16
        tf.layer.cornerCurve = .continuous
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = UIColor(hexCode: "D0D0D0").cgColor
        tf.autocapitalizationType = .none // 대문자
        tf.spellCheckingType = .no // 맞춤법
        tf.autocorrectionType = .no // 자동 수정
        // yourSingleFactorCodeTextField.textContentType = .oneTimeCode
        return tf
    }
    
    static func tel(placeholder: String, padding: CGFloat = 16) -> UITextField {
        let textField: UITextField = .common(placeholder: placeholder, padding: padding)
        textField.textContentType = .telephoneNumber
        textField.keyboardType = .phonePad
        return textField
    }
    
    static func password(placeholder: String, padding: CGFloat = 16) -> UITextField {
        let textField: UITextField = .common(placeholder: placeholder, padding: padding)
        textField.isSecureTextEntry = true
        return textField
    }
}

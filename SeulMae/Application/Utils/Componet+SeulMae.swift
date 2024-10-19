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
    
    static func user(image: UIImage = .userProfile) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.cornerCurve = .continuous
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        label.font = .systemFont(ofSize: 26, weight: .medium)
        return label
    }
    
    static func callout(title: String = "") -> UILabel {
        let label = UILabel()
        label.ext.setText(title, size: 16, weight: .regular)
        return label
    }
    
    static func footnote(title: String = "", color: UIColor = .secondaryLabel) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = .systemFont(ofSize: 14)
        return label
    }
    
    static func headline(title: String = "") -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.font = .pretendard(size: 18, weight: .regular)
        return label
    }
    
    static func body(title: String = "") -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.font = .pretendard(size: 14, weight: .regular)
        return label
    }
    
    static func common(title: String = "", typographic: Typographic) -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 0
        label.font = typographic.pretendard
        return label
    }
    
    static func common(title: String = "", size: CGFloat = 15, weight: UIFont.PretendardWeight = .regular, color: UIColor = .label, numOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = numOfLines
        label.font = .pretendard(size: size, weight: weight)
        label.textColor = color
        return label
    }
    
    enum Typographic {
        case largeTitle
        case title
        case headline
        case body
        case callout
        case subhead
        case footnote
        case caption
        
        //    Large Title Regular 31 38
        //    Title 1 Regular 25 31
        //    Title 2 Regular 19 24
        //    Title 3 Regular 17 22
        //    Headline Semibold 14 19
        //    Body Regular 14 19
        //    Callout Regular 13 18
        //    Subhead Regular 12 16
        //    Footnote Regular 12 16
        //    Caption 1 Regular 11 13
        //    Caption 2 Regular 11 13
        
        var pretendard: UIFont {
            switch self {
            case .largeTitle:
                return .pretendard(size: 31, weight: .regular)
            case .title:
                return .pretendard(size: 25, weight: .regular)
            case .headline:
                return .pretendard(size: 14, weight: .semibold)
            case .body:
                return .pretendard(size: 14, weight: .regular)
            case .callout:
                return .pretendard(size: 13, weight: .regular)
            case .subhead:
                return .pretendard(size: 12, weight: .regular)
            case .footnote:
                return .pretendard(size: 12, weight: .regular)
            case .caption:
                return .pretendard(size: 11, weight: .regular)
            }
        }
    }
}

// MARK: - UIButton

extension UIButton {
    static func half(title: String, highlight: Bool = true) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .pretendard(size: 18, weight: .medium)
        button.backgroundColor = highlight ? .primary : .lightGray
        button.setTitleColor(highlight ? .white : .primary, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        return button
    }
    
    static func common(
        title: String = "",
        size: CGFloat = 15,
        weight: UIFont.PretendardWeight = .regular,
        color: UIColor = .white,
        backgroundColor: UIColor? = .primary,
        cornerRadius: CGFloat = 8.0,
        layoutMargins: UIEdgeInsets = .zero
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .pretendard(size: size, weight: weight)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.layer.cornerCurve = .continuous
        button.contentEdgeInsets = layoutMargins
        return button
    }
    
    static func image(_ image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.layer.cornerRadius = 4.0
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = true
        return button
    }
    
    static func callout(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(hexCode: "676768"), for: .normal)
        button.titleLabel?.font = .pretendard(size: 15, weight: .regular)
        return button
    }
}

// MARK: - UITextField

extension UITextField {
    static func common(placeholder: String) -> UITextField {
        let tf = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        let attrString = NSAttributedString(
            string: placeholder,
            attributes: [
                .font: UIFont.pretendard(size: 15, weight: .regular),
                .foregroundColor: UIColor(hexCode: "1C2439")
                .withAlphaComponent(0.64)
            ])
        tf.attributedPlaceholder = attrString
        tf.layer.cornerRadius = 8
        tf.layer.cornerCurve = .continuous
        tf.autocapitalizationType = .none // 대문자
        tf.spellCheckingType = .no // 맞춤법
        tf.autocorrectionType = .no // 자동 수정
        tf.backgroundColor = UIColor(hexCode: "F4F7FC")
        return tf
    }
    
    static func tel(placeholder: String) -> UITextField {
        let textField: UITextField = .common(placeholder: placeholder)
        textField.textContentType = .telephoneNumber
        textField.keyboardType = .phonePad
        return textField
    }
    
    static func password(placeholder: String) -> UITextField {
        let textField: UITextField = .common(placeholder: placeholder)
        textField.isSecureTextEntry = true
        let showPasswordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        showPasswordButton.setImage(.eyeFill, for: .normal)
        showPasswordButton.setImage(.eyeSlashFill, for: .selected)
        showPasswordButton.contentVerticalAlignment = .fill
        showPasswordButton.contentHorizontalAlignment = .fill
        showPasswordButton.adjustsImageWhenHighlighted = false
        let buttonPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        buttonPaddingView.addSubview(showPasswordButton)
        showPasswordButton.center = buttonPaddingView.center
        textField.rightView = buttonPaddingView
        textField.rightViewMode = .always
        let action = UIAction(handler: { _ in
            showPasswordButton.isSelected.toggle()
            textField.isSecureTextEntry.toggle()
        })
        showPasswordButton.addAction(action, for: .touchUpInside)
        return textField
    }
}

//
//  UITextField+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

extension Ext where ExtendedType == UITextField {
    @discardableResult
    func backgroundColor(_ color: UIColor) -> UITextField {
        type.backgroundColor = color
        (type as? TF)?.offBackgroundColor = color
        return type
    }

    @discardableResult
    func backgroundColor(_ colorCode: String) -> UITextField {
        type.backgroundColor = UIColor.ext.hex(colorCode)
        (type as? TF)?.offBackgroundColor = UIColor.ext.hex(colorCode)
        return type
    }

    @discardableResult
    func font(_ font: UIFont) -> UITextField {
        type.font = font
        return type
    }

    @discardableResult
    func placeholder(_ placeholder: String, textColor: UIColor = .secondaryLabel) -> ExtendedType {
        let font = type.font ?? .pretendard(size: 16, weight: .regular)
        let attrString = NSAttributedString(
           string: placeholder,
           attributes: [
               .font: font,
               .foregroundColor: textColor,
           ])
        type.attributedPlaceholder = attrString
        return type
    }

    @discardableResult
    func pw() -> ExtendedType {
        type.isSecureTextEntry = true
        return type
    }

    @discardableResult
    func activeImage(image: UIImage) -> ExtendedType {
        let imageView = UIImageView
            .ext.common(image)
            .ext.frame(width: 24, height: 24)
        let paddingView = UIView()
            .ext.frame(width: 48, height: 48)
        paddingView.addSubview(imageView)
        imageView.center = paddingView.center
        type.rightView = paddingView
        type.rightViewMode = .always
        type.rightView?.isHidden = true
        (type as? TF)?.onBegin = { tf in
            tf.rightView?.isHidden = false
        }
        (type as? TF)?.onEnd = { tf in
            tf.rightView?.isHidden = true
        }
        return type
    }

    @discardableResult
    func rightView(_ view: UIView) -> ExtendedType {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        paddingView.addSubview(view)
        view.center = paddingView.center
        type.rightView = paddingView
        type.rightViewMode = .always
        return type
    }

    func setEditing(_ isEditing: Bool) {
        if isEditing {
            type.layer.borderColor = UIColor.graphite.cgColor
            type.layer.borderWidth = 1.0
        } else {
            type.layer.borderColor = nil
            type.layer.borderWidth = 0
        }
    }

    static func tf(
        placeholder: String = "",
        size: CGFloat = 15,
        weight: UIFont.PretendardWeight = .regular,
        backgroundColor: UIColor = UIColor(hexCode: "CAD1EA")
    ) -> UITextField {
        let tf = Ext.default()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 8.0
        tf.layer.cornerCurve = .continuous
        tf.backgroundColor = backgroundColor
        (tf as UITextField).ext.placeholder(placeholder)
        tf.onBorderColor = .ext.hex("4C71F5")
        tf.onBorderWidth = 2
        tf.onBackgroundColor = .white
        tf.offBorderColor = nil
        tf.offBorderWidth = 0
        tf.offBackgroundColor = backgroundColor
        return tf
    }
    
    @discardableResult
    func tel() -> ExtendedType {
        type.textContentType = .telephoneNumber
        type.keyboardType = .phonePad
        return type
    }

//    @discardableResult
//    func style(onBorderColor: String, onBorderWidth: String, offBorderColor: String, of) -> UITextField {
//        guard
//        tf.onBorderColor = onBorderColor
//        tf.onBorderWidth = onBorderWidth
//        tf.offBorderColor = offBorderColor
//        tf.offBorderWidth = offBorderWidth
//    }


    static func password(
        placeholder: String = "",
        size: CGFloat = 15,
        weight: UIFont.PretendardWeight = .regular,
        backgroundColor: UIColor = UIColor(hexCode: "CAD1EA")
    ) -> UITextField {
        let tf = Ext.tf()
        tf.isSecureTextEntry = true

        let showPasswordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        showPasswordButton.setImage(.eyeFill, for: .normal)
        showPasswordButton.setImage(.eyeSlashFill, for: .selected)
        showPasswordButton.contentVerticalAlignment = .fill
        showPasswordButton.contentHorizontalAlignment = .fill
        showPasswordButton.adjustsImageWhenHighlighted = false

        let buttonPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        buttonPaddingView.addSubview(showPasswordButton)

        showPasswordButton.center = buttonPaddingView.center
        
        tf.rightView = buttonPaddingView
        tf.rightViewMode = .always
        let action = UIAction(handler: { _ in
            showPasswordButton.isSelected.toggle()
            tf.isSecureTextEntry.toggle()
        })
        showPasswordButton.addAction(action, for: .touchUpInside)
        return tf
    }

    private static func `default`() -> TF {
        let tf = TF()
        tf.autocapitalizationType = .none // 대문자
        tf.spellCheckingType = .no // 맞춤법
        tf.autocorrectionType = .no // 자동 수정
        tf.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return tf
    }

    static func small(placeholder: String? = "",
                      placeholderColor: UIColor? = UIColor(hexCode: "D0D9F8"),
                      placeholderFont: UIFont? = UIFont.pretendard(size: 16, weight: .semibold),
                      font: UIFont? = .pretendard(size: 16, weight: .regular),
                      width: CGFloat,
                      onBorderColor: UIColor? = UIColor(hexCode: "4C71F5"),
                      onBorderWidth: CGFloat = 1.6,
                      offBorderColor: UIColor? = nil,
                      offBorderWidth: CGFloat = 0) -> TF {
        let tf = Ext.default()
        tf.backgroundColor = .white
        tf.textAlignment = .center
        tf.layer.cornerRadius = 8.0
        tf.layer.cornerCurve = .continuous
        tf.onBorderColor = onBorderColor
        tf.onBorderWidth = onBorderWidth
        tf.offBorderColor = offBorderColor
        tf.offBorderWidth = offBorderWidth
        tf.font = font
        let attrPH = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .font: placeholderFont!,
                .foregroundColor: placeholderColor!
            ])
        tf.attributedPlaceholder = attrPH
        tf.widthAnchor.constraint(equalToConstant: width).isActive = true
        tf.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return tf
    }

    class TF: UITextField, UITextFieldDelegate {
        var onBegin: ((UITextField) -> Void)?
        var onEnd: ((UITextField) -> Void)?

        var onBorderColor: UIColor?
        var onBorderWidth: CGFloat = 0
        var onBackgroundColor: UIColor?
        var offBorderColor: UIColor?
        var offBorderWidth: CGFloat = 0
        var offBackgroundColor: UIColor?

        convenience init() {
            self.init(frame: .zero)
            self.delegate = self
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            backgroundColor = onBackgroundColor
            layer.borderColor = onBorderColor?.cgColor ?? nil
            layer.borderWidth = onBorderWidth
            onBegin?(self)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            backgroundColor = offBackgroundColor
            layer.borderColor = offBorderColor?.cgColor ?? nil
            layer.borderWidth = offBorderWidth
            onEnd?(self)
        }
    }
}

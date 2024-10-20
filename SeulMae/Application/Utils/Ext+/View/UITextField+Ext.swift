//
//  UITextField+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

extension UITextField: Extended {}
extension Ext where ExtendedType == UITextField {
    static func common(
        placeholder: String = "",
        size: CGFloat = 15,
        weight: UIFont.PretendardWeight = .regular,
        backgroundColor: UIColor = UIColor(hexCode: "CAD1EA")
    ) -> UITextField {
        let textField = UITextField()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 8.0
        textField.layer.cornerCurve = .continuous
        textField.autocapitalizationType = .none // 대문자
        textField.spellCheckingType = .no // 맞춤법
        textField.autocorrectionType = .no // 자동 수정
        textField.backgroundColor = backgroundColor
        textField.ext.setPlaceholder(placeholder)
        return textField
    }

    func setPlaceholder(_ placeholder: String) {
        let font = type.font ?? .pretendard(size: 16, weight: .regular)
        let attrString = NSAttributedString(
           string: placeholder,
           attributes: [
               .font: font,
               .foregroundColor: UIColor(hexCode: "1C2439")
               .withAlphaComponent(0.64)
           ])
        type.attributedPlaceholder = attrString
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
}

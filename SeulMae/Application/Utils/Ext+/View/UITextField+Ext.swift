//
//  UITextField+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

extension UICollectionView: Extended {}
extension Ext where ExtendedType == UICollectionView {
    static func common(with emptyView: UIView? = nil) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        if let emptyView { collectionView.backgroundView = emptyView }
        return collectionView
    }
}

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

    static var common2: TF {
        let tf = TF()
        tf.autocapitalizationType = .none // 대문자
        tf.spellCheckingType = .no // 맞춤법
        tf.autocorrectionType = .no // 자동 수정
        return tf
    }

    static func template(style: Style) -> TF {
        let tf = Ext<UITextField>.common2
        switch style {
        case let .one(color: color, width: width):
            tf.textAlignment = .center
            tf.layer.cornerRadius = 8.0
            tf.layer.cornerCurve = .continuous
            tf.onBorderColor = color
            tf.onBorderWidth = width
            tf.offBorderColor = nil
            tf.font = .pretendard(size: 16, weight: .regular)
            let attrPH = NSAttributedString(
               string: "",
               attributes: [
                   .font: UIFont.pretendard(size: 16, weight: .semibold),
                   .foregroundColor: UIColor(hexCode: "D0D9F8")
               ])
            tf.attributedPlaceholder = attrPH
        }
        return tf
    }

    enum Style {
        case one(color: UIColor, width: CGFloat)

        static let one = one(color: UIColor(hexCode: "4C71F5"), width: 1.6)
    }

    class TF: UITextField, UITextFieldDelegate {
        var onBorderColor: UIColor?
        var onBorderWidth: CGFloat = 0
        var offBorderColor: UIColor?
        var offBorderWithd: CGFloat = 0

        convenience init() {
            self.init(frame: .zero)
            self.delegate = self
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            layer.borderColor = onBorderColor?.cgColor ?? nil
            layer.borderWidth = onBorderWidth
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            layer.borderColor = offBorderColor?.cgColor ?? nil
            layer.borderWidth = offBorderWithd
        }
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

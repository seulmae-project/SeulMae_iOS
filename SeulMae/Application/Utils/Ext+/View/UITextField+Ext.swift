//
//  UITextField+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

extension Ext where ExtendedType == UICollectionView {
    static func common(frame: CGRect = .zero,
                       layout: UICollectionViewLayout,
                       backgroundColor: UIColor? = nil,
                       emptyView: UIView? = nil,
                       refreshControl: UIRefreshControl) -> UICollectionView {
        let collectionView = UICollectionView(
            frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        collectionView.allowsMultipleSelection = true
        // collectionView.isUserInteractionEnabled = true

        if let emptyView { collectionView.backgroundView = emptyView }
        return collectionView
    }
}

extension Ext where ExtendedType == UITextField {

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

    static func common(
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
        (tf as UITextField).ext.setPlaceholder(placeholder)
        return tf
    }

    static func `default`() -> TF {
        let tf = TF()
        tf.autocapitalizationType = .none // 대문자
        tf.spellCheckingType = .no // 맞춤법
        tf.autocorrectionType = .no // 자동 수정
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
        var onBorderColor: UIColor?
        var onBorderWidth: CGFloat = 0
        var offBorderColor: UIColor?
        var offBorderWidth: CGFloat = 0

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
            layer.borderWidth = offBorderWidth
        }
    }
}

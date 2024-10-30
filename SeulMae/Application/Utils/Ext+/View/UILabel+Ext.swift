//
//  UILabel+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import UIKit

extension Ext where ExtendedType == UILabel {
    static func common(_ text: String? = "", 
                       font: UIFont,
                       textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        return label
    }

    static func config(font: UIFont, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        return label
    }

    @discardableResult
    func highlight(font: UIFont, textColor: String, words: String...) -> ExtendedType {
        let fullText = type.text ?? ""
        let attributed = NSMutableAttributedString(string: fullText)
        for word in words {
            let range = (fullText as NSString).range(of: word)
            attributed.addAttribute(.font, value: font, range: range)
            attributed.addAttribute(.foregroundColor, value: UIColor.ext.hex(textColor), range: range)
        }
        type.attributedText = attributed
        return type
    }

    func setText(_ text: String,
                 size: CGFloat,
                 weight: UIFont.PretendardWeight,
                 color: UIColor = .label,
                 lineHeightMultiple: CGFloat = 1.2,
                 kern: CGFloat = 1.0) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.pretendard(size: size, weight: weight),
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ]
        type.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    func setText(_ text: String,
                 lineHeightMultiple: CGFloat = 1.2,
                 kern: CGFloat = 1.0) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: type.textColor ?? .label,
            .font: type.font ?? .pretendard(size: 16, weight: .regular),
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ]
        type.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

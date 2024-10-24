//
//  UILabel+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import UIKit

extension Ext where ExtendedType == UILabel {
    static func common(_ text: String? = "") -> UILabel {
        let label = UILabel()
        
        return label
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

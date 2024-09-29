//
//  UILabel+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import UIKit

extension Extension where ExtendedType == UILabel {
    func setText(_ text: String,
                 size: CGFloat,
                 weight: UIFont.PretendardWeight,
                 lineHeightMultiple: CGFloat = 1.2,
                 kern: CGFloat = 1.0) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.pretendard(size: size, weight: weight),
            .kern: kern,
            .paragraphStyle: paragraphStyle
        ]
        type.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}

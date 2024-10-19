//
//  UIView+Bubbled.swift
//  SeulMae
//
//  Created by 조기열 on 10/3/24.
//

import UIKit

extension UIView {
    func bubbled(
        color: UIColor,
        horizontal h: CGFloat = 8.0,
        vertical v: CGFloat = 4.0,
        cornerRadius: CGFloat = 8.0
    ) -> UIView {
        let bubble = UIStackView()
        bubble.backgroundColor = color
        bubble.addArrangedSubview(self)
        let insets = NSDirectionalEdgeInsets(top: v, leading: h, bottom: v, trailing: h)
        bubble.directionalLayoutMargins = insets
        bubble.isLayoutMarginsRelativeArrangement = true
        bubble.layer.cornerRadius = cornerRadius
        bubble.layer.cornerCurve = .continuous
        return bubble
    }
}

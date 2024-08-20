//
//  UIView+Separator.swift
//  SeulMae
//
//  Created by 조기열 on 8/5/24.
//

import UIKit

extension UIView {
    static var separator: UIView {
        let separator = UIView()
        separator.backgroundColor = .init(hexCode: "E5E5E5")
        separator.heightAnchor
            .constraint(equalToConstant: 1.0)
            .isActive = true
        return separator
    }
}

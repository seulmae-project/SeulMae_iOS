//
//  UIStackView+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit

extension Ext where ExtendedType == UIStackView {
    
    @discardableResult
    func padding(horizontal: CGFloat, vertical: CGFloat) -> ExtendedType {
        let insets = NSDirectionalEdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
        type.directionalLayoutMargins = insets
        type.isLayoutMarginsRelativeArrangement = true
        return type
    }
}

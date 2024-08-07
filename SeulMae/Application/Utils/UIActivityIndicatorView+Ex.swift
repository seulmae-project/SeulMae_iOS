//
//  UIActivityIndicatorView+Ex.swift
//  SeulMae
//
//  Created by 조기열 on 8/7/24.
//

import UIKit

extension UIActivityIndicatorView: Extended {}
extension Extension where ExtendedType == UIActivityIndicatorView {
    func isAnimating(_ active: Bool) {
        if active {
            type.startAnimating()
        } else {
            type.stopAnimating()
        }
    }
}

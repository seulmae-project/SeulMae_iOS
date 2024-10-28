//
//  UIColor+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/7/24.
//

import class UIKit.UIColor

extension UIColor: Extended {}
extension Ext where ExtendedType == UIColor {
    static func hex(_ code: String) -> UIColor {
        return UIColor(hexCode: code)
    }
    static let detent = UIColor(hexCode: "7F7F7F", alpha: 0.4)
}

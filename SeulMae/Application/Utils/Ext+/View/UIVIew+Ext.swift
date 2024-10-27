//
//  UIVIew+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit

extension UIView: Extended {}
extension Ext where ExtendedType == UIView {
    static func empty(message: String, action: String) -> UIView {
        let view = Ext.empty(message: message)
        return view
    }

    static func empty(message: String) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = message
        return view
    }
}

//
//  UIVIew+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit

extension UIView: Extended {}
extension Ext where ExtendedType: UIView {
    @discardableResult
    func frame(width: Int, height: Int) -> ExtendedType {
        type.frame = CGRect(x: 0, y: 0, width: width, height: height)
        return type
    }

    @discardableResult
    func size(width: CGFloat? = nil, height: CGFloat? = nil) -> ExtendedType {
        if let width {
            type.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height {
            type.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        return type
    }

    @discardableResult
    func centerX(match anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> ExtendedType {
        type.translatesAutoresizingMaskIntoConstraints = false
        type.centerXAnchor.constraint(equalTo: anchor, constant: constant)
            .isActive = true
        return type
    }

    @discardableResult
    func fromTop(to anchor: NSLayoutYAxisAnchor, constant: CGFloat) -> ExtendedType {
        type.translatesAutoresizingMaskIntoConstraints = false
        type.topAnchor.constraint(equalTo: anchor, constant: constant)
            .isActive = true
        return type
    }

    @discardableResult
    func fromLeading(to anchor: NSLayoutXAxisAnchor, constant: CGFloat) -> ExtendedType {
        type.translatesAutoresizingMaskIntoConstraints = false
        type.leadingAnchor.constraint(equalTo: anchor, constant: constant)
            .isActive = true
        return type
    }

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

    static var separator: UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return separator
    }

    static var divider: UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        return separator
    }



    func someisCenterY(_ subview: UIView,
                               isCenterY: Bool = false,
                               top: NSLayoutYAxisAnchor? = nil,
                               leading: NSLayoutXAxisAnchor? = nil,
                               bottom: NSLayoutYAxisAnchor? = nil,
                               trailing: NSLayoutXAxisAnchor? = nil,
                               topInset: CGFloat = 0, leadingInset: CGFloat = 0, bottomInset: CGFloat = 0,  trailingInset: CGFloat = 0,
                               width: CGFloat? = nil, height: CGFloat? = nil) {
        //addSubview(subview)

        subview.translatesAutoresizingMaskIntoConstraints = false

//        if isCenterY {
//            subview.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        }

        if let top = top {
            subview.topAnchor.constraint(equalTo: top, constant: topInset).isActive = true
        }

        if let leading = leading {
            subview.leadingAnchor.constraint(equalTo: leading, constant: leadingInset).isActive = true
        }

        if let bottom = bottom {
            subview.bottomAnchor.constraint(equalTo: bottom, constant: -1 * bottomInset).isActive = true
        }

        if let trailing = trailing {
            subview.trailingAnchor.constraint(equalTo: trailing, constant: -1 * trailingInset).isActive = true
        }

        if let width = width {
            subview.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

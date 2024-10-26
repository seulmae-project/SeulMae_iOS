//
//  UIButton+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/24/24.
//

import UIKit

extension UIButton: Extended {}

extension Ext {
    enum Property {
        case title(String)
    }

    enum Design {
        case image(UIImage)
        case font(UIFont)
        case color(UIColor)
    }

    enum Layout {
        case axis(Axis)
        case position(Postion)
    }

    enum Axis {
        case v, h
    }

    enum Postion {
        case l, tr, t, b
    }
}

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

extension UIImageView: Extended {}
extension Ext where ExtendedType == UIImageView {
    static func image(_ image: UIImage,
                      width: CGFloat = 44,
                      height: CGFloat = 44) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return imageView
    }

    static func config(width: CGFloat,
                       height: CGFloat,
                       cornerRadius: CGFloat
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .placeFinderSample
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.cornerCurve = .continuous
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return imageView
    }

    static func user() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .userProfile
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 22
        imageView.layer.cornerCurve = .continuous
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }

    func url(_ url: String?) {
        // let isValid =
    }

    static func template(_ any: [Any]) -> UIImageView {
        let iv = _IV()
        let designs: [Design] = any.compactMap { $0 as? Design }
        designs.forEach(iv.apply(_:))
        return iv
    }

    class _IV: UIImageView {
        func apply(_ design: Design) {
            switch design {
            case let .image(_image): image = _image
            case let .font(font): break
            case let .color(color): break
            }
        }
    }
}

extension Ext where ExtendedType == UIButton {
    static func config(font: UIFont, color: UIColor) -> UIButton {
        let button = UIButton()
        button.titleLabel?.font = font
        button.setTitleColor(color, for: .normal)
        return button
    }

    static func image(_ image: UIImage,
                      width: CGFloat = 44,
                      height: CGFloat = 44) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        return button
    }

    static func common(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .pretendard(size: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexCode: "4C71F5")
        button.layer.cornerRadius = 8.0
        button.layer.cornerCurve = .continuous
        button.heightAnchor.constraint(equalToConstant: 52).isActive = true
        return button
    }

    static func small(title: String, font: UIFont = .pretendard(size: 16, weight: .bold)) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(UIColor(hexCode: "4C71F5"), for: .normal)
        button.backgroundColor = UIColor(hexCode: "F2F5FF")
        button.layer.cornerRadius = 8.0
        button.layer.cornerCurve = .continuous
        // button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        let insets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        button.contentEdgeInsets = insets
        return button
    }


    static func template(_ any: [Any]) -> UIButton {
        let bt = _BT()
        let designs: [Design] = any.compactMap { $0 as? Design }
        designs.forEach(bt.apply(_:))
        return bt
    }

    class _BT: UIButton {
        func apply(_ design: Design) {
            switch design {
            case let .image(image):
                setImage(image, for: .normal)
            case let .font(font):
                titleLabel?.font = font
            case let .color(color):
                setTitleColor(color, for: .normal)
            }
        }
    }
}

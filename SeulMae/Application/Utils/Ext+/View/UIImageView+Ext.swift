//
//  UIImageView+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit

extension UIImageView {


}

extension Ext where ExtendedType == UIImageView {
    

    @discardableResult
    static func common(_ image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
    }

    // func size()

    static func image(_ image: UIImage,
                      width: CGFloat = 44,
                      height: CGFloat = 44,
                      cornerRadius: CGFloat? = nil,
                      bolderWidth: CGFloat? = nil,
                      bolderColor: UIColor? = nil
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: height).isActive = true

        if let cornerRadius {
            imageView.layer.cornerRadius = cornerRadius
            imageView.layer.cornerCurve = .continuous
            imageView.layer.masksToBounds = true
        }

        if let bolderWidth {
            imageView.layer.borderColor = bolderColor?.cgColor
            imageView.layer.borderWidth = bolderWidth
            imageView.layer.shadowOffset = CGSize(width: 0, height: 3)
        }

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
}

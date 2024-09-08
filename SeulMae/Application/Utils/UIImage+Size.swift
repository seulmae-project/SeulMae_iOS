//
//  UIImage+Size.swift
//  SeulMae
//
//  Created by 조기열 on 9/8/24.
//

import UIKit

extension UIImage {
    func resize(height: CGFloat) -> UIImage? {
        let heightRatio = height / size.height
        let newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

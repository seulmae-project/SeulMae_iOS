//
//  NSDirectionalEdgeInsets+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/20/24.
//

import UIKit

extension NSDirectionalEdgeInsets: Extended {}
extension Ext where ExtendedType == NSDirectionalEdgeInsets {

    static func all(_ inset: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(
            top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}


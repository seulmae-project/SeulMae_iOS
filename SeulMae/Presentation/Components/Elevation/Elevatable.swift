//
//  Elevatable.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import Foundation

protocol Elevatable {
    var currentElevation: CGFloat { get }
    var elevationDidChangeBlock: ((Elevatable, CGFloat) -> Void)? { get set }
}

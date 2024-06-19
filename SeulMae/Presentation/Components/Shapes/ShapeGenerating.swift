//
//  ShapeGenerating.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import UIKit

@available(iOS, deprecated: 12.12, message: "🤖👀 Use layer.cornerRadius to achieve rounded corners. This has go/material-ios-migrations#scriptable-potential 🤖👀.")
protocol ShapeGenerating: NSCopying {
    func path(for size: CGSize) -> CGPath?
}

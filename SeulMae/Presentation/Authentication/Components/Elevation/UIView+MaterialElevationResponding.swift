//
//  UIView+MaterialElevationResponding.swift
//  SeulMae
//
//  Created by 조기열 on 6/19/24.
//

import UIKit

@available(iOS, deprecated: 12.12, message: "🤖👀 Use colors with dynamic providers that handle elevation instead. See go/material-ios-color/gm2-migration and go/material-ios-elevation/gm2-migration for more info. This has go/material-ios-migrations#scriptable-potential 🤖👀.")
extension UIView {
    @available(iOS, deprecated)
    var mdc_baseElevation: CGFloat {
        return 0.0 // Replace with appropriate implementation
    }

    @available(iOS, deprecated)
    var mdc_absoluteElevation: CGFloat {
        return 0.0 // Replace with appropriate implementation
    }
    
    @available(iOS, deprecated)
    func mdc_elevationDidChange() {
        // Implement your logic here
    }
}

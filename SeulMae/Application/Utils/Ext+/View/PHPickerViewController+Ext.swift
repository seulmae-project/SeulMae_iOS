//
//  PHPickerViewController+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/27/24.
//

import UIKit
import PhotosUI

extension Ext where ExtendedType == PHPickerViewController {
    static func common() -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerViewController = PHPickerViewController(configuration: configuration)
        return pickerViewController
    }
}

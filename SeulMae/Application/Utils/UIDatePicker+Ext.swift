//
//  UIDatePicker+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/5/24.
//

import UIKit

extension UIDatePicker: Extended {}
extension Ext where ExtendedType == UIDatePicker {
    
    static var date: UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }
    
    static var time: UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        return picker
    }
}

//
//  UITextView+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/5/24.
//

import UIKit

extension Ext where ExtendedType == UITextView {
    
    static func common(placeholder: String = "") -> UITextView {
        let textView = _TextView()
        textView.backgroundColor = .textView
        textView.placeholder = placeholder
        textView.layer.cornerRadius = 12
        textView.layer.cornerCurve = .continuous
        textView.font = .pretendard(size: 16, weight: .regular)
        textView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        return textView
    }
}


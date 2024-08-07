//
//  BindingExtensions+ValidationResult.swift
//  SeulMae
//
//  Created by 조기열 on 6/17/24.
//

import UIKit
import RxSwift
import RxCocoa

extension ValidationResult: CustomStringConvertible {
    var description: String {
        switch self {
        case let .ok(message):
            return message
        case .empty:
            return ""
        case .validating:
            return "validating ..."
        case let .failed(message):
            return message
        }
    }
}

struct ValidationColors {
    static let okColor = UIColor(hexCode: "0086FF")
    static let errorColor = UIColor(hexCode: "FF453A")
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .ok:
            return ValidationColors.okColor
        case .empty:
            return .label
        case .validating:
            return .label
        case .failed:
            return ValidationColors.errorColor
        }
    }
}

extension Reactive where Base: UILabel {
    var validationResult: Binder<ValidationResult> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}

extension UILabel: Extended {}
extension Extension where ExtendedType == UILabel {
    func setResult(_ result: ValidationResult) {
        type.textColor = result.textColor
        type.text = result.description
    }
}

extension UIButton: Extended {}
extension Extension where ExtendedType == UIButton {
    func setEnabled(_ isEnabled: Bool) {
        type.isEnabled = isEnabled
        // type.alpha = isEnabled ? 1.0 : 0.5
        type.backgroundColor = isEnabled ? .primary : .cloudy
        type.setTitleColor(isEnabled ? .cloudy : .graphite, for: .normal)
    }
}

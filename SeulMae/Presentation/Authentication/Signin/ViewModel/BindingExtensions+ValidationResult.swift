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
        case .default(let message),
                .ok(let message),
                .failed(let message),
                .empty(let message):
            return message
        case .validating:
            return "validating..."
        }
    }
}

struct ValidationColors {
    static let ok: UIColor = UIColor.primary
    static let error = UIColor(hexCode: "FF453A")
    static let `default`: UIColor = .graphite
}

extension ValidationResult {
    var textColor: UIColor {
        switch self {
        case .default, .empty, .validating:
            return ValidationColors.default
        case .ok:
            return ValidationColors.ok
        case .failed:
            return ValidationColors.error
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
        type.backgroundColor = isEnabled ? .primary : .cloudy
        type.setTitleColor(isEnabled ? .cloudy : .graphite, for: .normal)
    }
}

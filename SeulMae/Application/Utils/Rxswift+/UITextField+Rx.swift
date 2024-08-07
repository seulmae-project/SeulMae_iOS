//
//  UITextField+Rx.swift
//  SeulMae
//
//  Created by 조기열 on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {
    var editing: ControlProperty<Bool> {
        return value
    }

    var value: ControlProperty<Bool> {
        return base.rx.controlProperty(
            editingEvents: [.editingDidBegin, .editingDidEnd],
            getter: { tf in
                tf.isFirstResponder
            }, setter: { tf, state in
                if tf.isFirstResponder && !state {
                    tf.resignFirstResponder()
                }
            }
        )
    }
}
            

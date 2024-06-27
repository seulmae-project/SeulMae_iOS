//
//  UIButton+Rx.swift
//  
//
//  Created by 조기열 on 6/27/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    var tag: ControlProperty<Int> {
        return value
    }
    
    var value: ControlProperty<Int> {
        base.rx.controlProperty(
            editingEvents: [.touchUpInside],
            getter: { button in
                button.tag
            },
            setter: { button, value in
                if button.tag != value {
                    button.tag = value
                }
            }
        )
    }
}
            

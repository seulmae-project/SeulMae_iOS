//
//  PHPickerViewController+Rx.swift
//  
//
//  Created by 조기열 on 2023/08/22.
//

import RxSwift
import RxCocoa
import UIKit
import PhotosUI

extension Reactive where Base: PHPickerViewController {
    public var delegate: DelegateProxy<PHPickerViewController, PHPickerViewControllerDelegate> {
        return RxPHPickerViewControllerDelegateProxy.proxy(for: base)
    }
    
    public var picked: ControlEvent<UIImage> {
        let source = RxPHPickerViewControllerDelegateProxy.proxy(for: base).pickedPublishSubject
        return ControlEvent(events: source)
    }
    
    public var data: ControlEvent<Data> {
        let source = picked.compactMap { $0.jpegData(compressionQuality: 0.75) }
        return ControlEvent(events: source)
    }
}

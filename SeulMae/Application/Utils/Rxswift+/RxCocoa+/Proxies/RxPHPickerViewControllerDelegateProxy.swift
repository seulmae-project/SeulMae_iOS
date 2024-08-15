//
//  PHPickerViewControllerDelegateProxy.swift
//  LeafTalk
//
//  Created by 조기열 on 2023/08/22.
//

import RxSwift
import RxCocoa
import UIKit
import PhotosUI


extension PHPickerViewController: HasDelegate {
    public typealias Delegate = PHPickerViewControllerDelegate
}

open class RxPHPickerViewControllerDelegateProxy: DelegateProxy<PHPickerViewController, PHPickerViewControllerDelegate>, DelegateProxyType {
    public weak private(set) var phPickerViewController: PHPickerViewController?

    public init(phPickerViewController: ParentObject) {
        self.phPickerViewController = phPickerViewController
        super.init(parentObject: phPickerViewController, delegateProxy: RxPHPickerViewControllerDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxPHPickerViewControllerDelegateProxy(phPickerViewController: $0) }
    }
    
    private var _pickedPublishSubject: PublishSubject<UIImage>?
    
    internal var pickedPublishSubject: PublishSubject<UIImage> {
        if let subject = _pickedPublishSubject {
            return subject
        }

        let subject = PublishSubject<UIImage>()
        _pickedPublishSubject = subject

        return subject
    }
    
    deinit {
        if let subject = _pickedPublishSubject {
            subject.on(.completed)
        }
    }
}

extension RxPHPickerViewControllerDelegateProxy: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProviders = results.map { $0.itemProvider }
        guard let itemProvider = itemProviders.first,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
        _ = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self = self,
                  let image = image as? UIImage,
                  let subject = self._pickedPublishSubject else { return }
            subject.on(.next(image))
        }
    }
}

//
//  UIActivityIndicatorView+Ext.swift
//  SeulMae
//
//  Created by 조기열 on 10/29/24.
//

import UIKit
import RxSwift
import RxCocoa

extension Ext where ExtendedType == UIActivityIndicatorView {

    // MARK: - RxCocoa Binder

    var isAnimating: Binder<Bool> {
        Binder<Bool>(type, binding: { indicator, loading in
            if loading {
                let view = indicator.superview
                view?.bringSubviewToFront(indicator)
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        })
    }
}

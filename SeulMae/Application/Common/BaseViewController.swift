//
//  BaseViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()

    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
    }
}

extension UIActivityIndicatorView: Extended {}
extension Ext where ExtendedType == UIActivityIndicatorView {
    func isAnimating(_ active: Bool) {
        if active {
            type.superview?.bringSubviewToFront(type)
            type.startAnimating()
        } else {
            type.stopAnimating()
        }
    }
}






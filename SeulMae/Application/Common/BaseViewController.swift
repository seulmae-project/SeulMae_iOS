//
//  BaseViewController.swift
//  SeulMae
//
//  Created by 조기열 on 9/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    var loadingIndicator: UIActivityIndicatorView!
    var refreshControl: UIRefreshControl!
    var onLoad: Signal<()>!
    var onRefresh: Signal<()>!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadBaseComponents()
    }

    func loadBaseComponents() {
        onLoad = rx.methodInvoked(#selector(viewWillAppear(_:)))
           .map { _ in return () }
           .asSignal()

        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)

        refreshControl = UIRefreshControl()
        onRefresh = refreshControl.rx.controlEvent(.valueChanged).asSignal()
        onRefresh.withUnretained(self)
            .delay(.seconds(1))
            .emit(onNext: { (self, _) in
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)

        let onBackgroundTap = UITapGestureRecognizer()
        onBackgroundTap.cancelsTouchesInView = false
        view.addGestureRecognizer(onBackgroundTap)
        onBackgroundTap.rx.event.asSignal()
            .withUnretained(self)
            .emit(onNext: { (self, gesture) in
                let location = gesture.location(in: self.view)
                let hitView = self.view.hitTest(location, with: nil)
                if (hitView === self.view) {
                    self.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension Ext where ExtendedType == UIActivityIndicatorView {
    func bind(_ active: Bool) {
        if active {
            type.superview?.bringSubviewToFront(type)
            type.startAnimating()
        } else {
            type.stopAnimating()
        }
    }
}






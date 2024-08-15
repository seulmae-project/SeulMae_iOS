//
//  SliderView+Rx.swift
//  SeulMae
//
//  Created by 조기열 on 7/20/24.
//

import RxSwift
import RxCocoa

protocol Sendable: AnyObject {
    associatedtype Item
    var onItemTap: ((Item) -> Void)? { get set }
}

extension Reactive where Base: Sendable {
    var tap: Observable<Base.Item> {
        return Observable.create { [weak sender = self.base] observer in
            MainScheduler.ensureRunningOnMainThread()

            guard let sender = sender else {
                observer.on(.completed)
                return Disposables.create()
            }

            sender.onItemTap = { item in
                observer.on(.next(item))
            }

            return Disposables.create {
                sender.onItemTap = nil
            }
        }
    }
}

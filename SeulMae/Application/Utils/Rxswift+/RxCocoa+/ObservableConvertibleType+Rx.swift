//
//  ObservableConvertibleType+Driver.swift
//
//
//  Created by 조기열 on 5/29/24.
//

import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    
    public func asDriver() -> Driver<Element> {
        return self.asDriver { error in
            #if DEBUG
                Swift.print("Somehow driver received error:\n\(error)")
                return Driver.empty()
            #else
                return Driver.empty()
            #endif
        }
    }
    
    public func asSignal() -> Signal<Element> {
        return self.asSignal() { error in
            #if DEBUG
                Swift.print("Somehow signal received error:\n\(error)")
                return Signal.empty()
            #else
                return Signal.empty()
            #endif
        }
    }
}

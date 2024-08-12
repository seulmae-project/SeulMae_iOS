//
//  WeakArray.swift
//  SeulMae
//
//  Created by 조기열 on 6/12/24.
//

import Foundation

final class Weak<T: AnyObject> {
    weak var value: T?
    init(_ value: T) {
        self.value = value
    }
}

@propertyWrapper
struct WeakArray<T: AnyObject> {
    private var value: [Weak<T>]
    
    var wrappedValue: [T] {
        get {
            value.compactMap(\.value)
        }
        set {
            if let weakArray = newValue as? [Weak<T>] {
                value = weakArray
            } else {
                value = newValue.map(Weak.init)
            }
        }
    }
    
    init(wrappedValue initialValue: [T]) {
        self.value = initialValue.map(Weak.init)
    }
}

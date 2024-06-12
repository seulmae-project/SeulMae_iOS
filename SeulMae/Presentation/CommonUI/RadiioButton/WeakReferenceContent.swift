//
//  WeakReferenceContent.swift
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
struct WeakReferenceContent<T: AnyObject> {
    private var value: [Weak<T>]
    
    var wrappedValue: [T] {
        get {
            value.compactMap(\.value)
        }
        set {
            value = newValue.map(Weak.init)
        }
    }
    
    init(wrappedValue initialValue: [T]) {
        self.value = initialValue.map(Weak.init)
    }
}

//
//  UIKitState.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/04/20.
//

import Foundation

@propertyWrapper
@Observable
@MainActor
public final class UIKitState<Value> {
    public private(set) var value: Value
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public init (wrappedValue: Value) {
        self.value = wrappedValue
    }
}

//
//  UIKitState.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/04/20.
//

import Foundation

@Observable
@MainActor
public final class ObservableValue<Value> {
    var value: Value
    init(value: Value) {
        self.value = value
    }
}

@propertyWrapper
@MainActor
public final class UIKitState<Value> {
    public private(set) var projectedValue: ObservableValue<Value>!

    public var wrappedValue: Value {
        get {
            projectedValue.value
        }
        set {
            projectedValue.value = newValue
        }
    }

    public init (wrappedValue: Value) {
        projectedValue = .init(value: wrappedValue)
    }

    deinit {
        projectedValue = nil
    }
}

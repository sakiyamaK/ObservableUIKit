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

    public var wrappedValue: Value
    public init (wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }

    public var projectedValue: (@MainActor () -> Value) {
        method
    }
    private func method() -> Value {
        wrappedValue
    }
}

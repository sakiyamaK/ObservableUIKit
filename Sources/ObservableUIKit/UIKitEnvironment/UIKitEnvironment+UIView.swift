//
//  UIKitEnvironment+UIView.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/08/24.
//

import UIKit
import SwiftUI

@MainActor
public protocol ReadEnvironmentable { }
public extension ReadEnvironmentable where Self: UIView {
    @discardableResult
    func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, state: UIKitState<V>) -> Self {
        var newValues = self.environmentValues
        newValues[ObjectIdentifier(keyPath)] = state
        self.environmentValues = newValues
        return self
    }

    @discardableResult
    func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, value: V) -> Self {
        environment(keyPath, state: UIKitState(wrappedValue: value))
    }

    @MainActor
    @discardableResult
    func tracking<Value>(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        onChange: @escaping (@MainActor (Self, Value) -> Void)
    ) -> Self {
        self.addSubview(
            HelperReadEnvironmentView(
                keyPath: keyPath,
                onChange: onChange
            )
        )
        return self
    }

    @MainActor
    @discardableResult
    func tracking<Value>(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        to parameterKeyPath: WritableKeyPath<Self, Value>
    ) -> Self {
        self.addSubview(
            HelperReadEnvironmentView(
                keyPath: keyPath,
                parameterKeyPath: parameterKeyPath
            )
        )
        return self
    }
}
extension UIView: ReadEnvironmentable {}

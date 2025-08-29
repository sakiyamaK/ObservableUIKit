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
    func environment<Value>(_ keyPath: WritableKeyPath<EnvironmentValues, Value>, _ apply: @escaping @MainActor () -> Value) -> Self {
        var newValues = self.environmentValues
        newValues[ObjectIdentifier(keyPath)] = apply
        self.environmentValues = newValues
        return self
    }

    @discardableResult
    func environment<Value>(_ keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) -> Self {
        environment(keyPath, { @MainActor in value })
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

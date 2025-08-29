//
//  UIKitEnvironment+UIViewController.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/08/24.
//

import UIKit
import SwiftUI

public extension ReadEnvironmentable where Self: UIViewController {
    @discardableResult
    func environment<Value>(_ keyPath: WritableKeyPath<EnvironmentValues, Value>, _ apply: @escaping @MainActor () -> Value) -> Self {
        var newValues = self.view.environmentValues
        newValues[ObjectIdentifier(keyPath)] = apply
        self.view.environmentValues = newValues
        return self
    }

    @discardableResult
    func environment<Value>(_ keyPath: WritableKeyPath<EnvironmentValues, Value>, value: Value) -> Self {
        environment(keyPath, { @MainActor in value })
    }
}
extension UIViewController: ReadEnvironmentable {}


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
    func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, state: UIKitState<V>) -> Self {
        var newValues = self.view.environmentValues
        newValues[ObjectIdentifier(keyPath)] = state
        self.view.environmentValues = newValues
        return self
    }

    @discardableResult
    func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, value: V) -> Self {
        environment(keyPath, state: UIKitState(wrappedValue: value))
    }
}
extension UIViewController: ReadEnvironmentable {}


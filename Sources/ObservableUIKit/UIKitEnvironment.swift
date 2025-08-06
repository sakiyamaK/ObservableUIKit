//
//  UIKitEnvironment.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/08/07.
//

import UIKit
import SwiftUICore

public protocol ReadEnvironmentable {}
public extension ReadEnvironmentable where Self: UIView {
    @MainActor @discardableResult
    func read<V>(environment keyPath: WritableKeyPath<EnvironmentValues, V>, _ onChange: @escaping (@MainActor (Self, V) -> Void)) -> Self {
        self.addSubview(
            HelperReadEnvironmentView(keyPath: keyPath, onChange: onChange)
        )
        return self
    }

    @MainActor @discardableResult
    func read<V>(environment keyPath: WritableKeyPath<EnvironmentValues, V>, to  parameterKeyPath: WritableKeyPath<Self, V>) -> Self {
        self.addSubview(
            HelperReadEnvironmentView(keyPath: keyPath, parameterKeyPath: parameterKeyPath)
        )
        return self
    }
}
extension UIView: ReadEnvironmentable {}

public extension UIView {
    @discardableResult
    func environment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>, _ value: UIKitState<V>) -> Self {
        var newValues = self.environmentValues
        newValues[ObjectIdentifier(keyPath)] = value
        self.environmentValues = newValues
        return self
    }
}

fileprivate extension UIView {
    private struct AssociatedKeys {
        @MainActor static var environmentValues: UInt8 = 0
    }

    var environmentValues: [ObjectIdentifier: Any] {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.environmentValues) as? [ObjectIdentifier: Any] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.environmentValues, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func readEnvironment<V>(_ keyPath: WritableKeyPath<EnvironmentValues, V>) -> UIKitState<V> {
        if let value = self.environmentValues[ObjectIdentifier(keyPath)] as? UIKitState<V> {
            value
        } else if let superview = self.superview {
            superview.readEnvironment(keyPath)
        } else {
            UIKitState<V>(wrappedValue: EnvironmentValues()[keyPath: keyPath])
        }
    }
}

fileprivate final class HelperReadEnvironmentView<Value, View: UIView>: UIView {
    private let keyPath: WritableKeyPath<EnvironmentValues, Value>
    private let parameterKeyPath: WritableKeyPath<View, Value>?
    private(set) var onChange: (@MainActor (View, Value) -> Void)?

    init(
        keyPath: WritableKeyPath<EnvironmentValues, Value>,
        parameterKeyPath: WritableKeyPath<View, Value>? = nil,
        onChange: (@MainActor (View, Value) -> Void)? = nil
    ) {
        self.keyPath = keyPath
        self.parameterKeyPath = parameterKeyPath
        self.onChange = onChange
        super.init(frame: .zero)
        self.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard window != nil, let superview = superview as? View else {
            return
        }

        let state = superview.readEnvironment(keyPath)

        if let onChange {
            superview.tracking({
                state.value
            }, onChange: onChange)
            removeFromSuperview()
        } else if let parameterKeyPath {
            superview.tracking({
                state.value
            }, to: parameterKeyPath)
            removeFromSuperview()
        }
    }

}

//
//  HelperReadEnvironmentView.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/08/24.
//

import UIKit
import SwiftUI

extension UIView {
    private struct AssociatedKeys {
        @MainActor static var environmentValuesKey = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
    }

    var environmentValues: [ObjectIdentifier: Any] {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.environmentValuesKey) as? [ObjectIdentifier: Any] ?? [:]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.environmentValuesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func readEnvironment<Value>(_ keyPath: WritableKeyPath<EnvironmentValues, Value>) -> (@MainActor () -> Value) {
        if let value = self.environmentValues[ObjectIdentifier(keyPath)] as? (@MainActor () -> Value) {
            value
        } else if let superview = self.superview {
            superview.readEnvironment(keyPath)
        } else {
            { @MainActor in
                EnvironmentValues()[keyPath: keyPath]
            }
        }
    }
}

final class HelperReadEnvironmentView<Value, View: UIView>: UIView {
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

        let apply = superview.readEnvironment(keyPath)

        if let onChange {
            superview.tracking(apply, onChange: onChange)
            removeFromSuperview()
        } else if let parameterKeyPath {
            superview.tracking(apply, to: parameterKeyPath)
            removeFromSuperview()
        }
    }
}

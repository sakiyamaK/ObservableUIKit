//
//  ReadEnvironmentable.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/08/07.
//

import UIKit
import SwiftUICore

@MainActor
@propertyWrapper public struct UIKitEnvironment<Value> {

    public var projectedValue: WritableKeyPath<EnvironmentValues, Value> {
        keyPath
    }

    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private let keyPath: WritableKeyPath<EnvironmentValues, Value>

    public init(_ keyPath: WritableKeyPath<EnvironmentValues, Value>) {
        self.keyPath = keyPath
    }
}


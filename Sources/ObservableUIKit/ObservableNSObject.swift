//
//  ObservableNSObject.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2024/12/27.
//

import UIKit

public protocol ObservableUIKit: AnyObject, Sendable {}
public extension ObservableUIKit {

    @available(*, deprecated, message: "observation is deprecated. Use tracking/trackingOptional instead")
    @MainActor
    @discardableResult
    func observation<T>(
        tracking:  @escaping @Sendable @MainActor () -> T,
        onChange: @escaping (@Sendable @MainActor (Self, T) -> Void),
        useInitialValue: Bool = true,
        shouldStop: @escaping (@Sendable () -> Bool) = { false }
    ) -> Self {

        if useInitialValue {
            onChange(self, tracking())
        }

        _ = withObservationTracking(tracking, onChange: {[weak self] in

            guard let self else { return }

            Task { @MainActor in
                onChange(self, tracking())

                if shouldStop() {
                    return
                }

                self.observation(
                    tracking: tracking,
                    onChange: onChange,
                    useInitialValue: useInitialValue,
                    shouldStop: shouldStop
                )
            }
        })
        return self
    }

    @MainActor
    @discardableResult
    func tracking<T>(
        useInitialValue: Bool = true,
        sendOptional: Bool = false,
        shouldStop: @escaping (@Sendable () -> Bool) = { false },
        _ apply: @escaping @Sendable @MainActor () -> T?,
        onChange: @escaping (@Sendable @MainActor (Self, T) -> Void)
    ) -> Self {

        if useInitialValue, let value = apply() {
            onChange(self, value)
        }

        _ = withObservationTracking(apply, onChange: {[weak self] in

            Task { @MainActor in
                guard let self, let value = apply() else { return }

                onChange(self, value)

                if shouldStop() {
                    return
                }

                self.tracking(
                    useInitialValue: useInitialValue,
                    shouldStop: shouldStop,
                    apply,
                    onChange: onChange
                )
            }
        })
        
        return self
    }

    @MainActor
    @discardableResult
    func trackingOptional<T>(
        useInitialValue: Bool = true,
        shouldStop: @escaping (@Sendable () -> Bool) = { false },
        _ apply: @escaping @Sendable @MainActor () -> T?,
        onChange: @escaping (@Sendable @MainActor (Self, T?) -> Void)
    ) -> Self {

        if useInitialValue {
            onChange(self, apply())
        }

        _ = withObservationTracking(apply, onChange: {[weak self] in

            Task { @MainActor in
                guard let self else { return }

                onChange(self, apply())

                if shouldStop() {
                    return
                }

                self.tracking(
                    useInitialValue: useInitialValue,
                    shouldStop: shouldStop,
                    apply,
                    onChange: onChange
                )
            }
        })
        return self
    }
}

extension UIView: @retroactive Sendable {}
extension UIView: ObservableUIKit {}
extension UIViewController: @retroactive Sendable {}
extension UIViewController: ObservableUIKit {}

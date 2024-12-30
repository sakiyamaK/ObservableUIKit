//
//  ObservableNSObject.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2024/12/27.
//

import UIKit

public protocol ObservableUIKit: AnyObject, Sendable {}
public extension ObservableUIKit {
    @MainActor
    @discardableResult
    func observation<T>(
        tracking: @escaping @Sendable @MainActor () -> T,
        onChange: @escaping (@Sendable @MainActor (Self, T) -> Void),
        shouldStop: @escaping (@Sendable () -> Bool) = { false },
        useInitialValue: Bool = true,
        mainThread: Bool = true
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
                    shouldStop: shouldStop,
                    useInitialValue: useInitialValue,
                    mainThread: mainThread
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

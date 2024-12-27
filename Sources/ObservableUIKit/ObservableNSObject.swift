//
//  ObservableNSObject.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2024/12/27.
//

import Foundation

public protocol ObservableNSObject {}
public extension ObservableNSObject {
    @discardableResult
    func observation<T>(
        tracking: @escaping (() -> T),
        onChange: @escaping @Sendable ((Self, T) -> Void),
        shouldStop: (@Sendable () -> Bool)? = nil,
        useInitialValue: Bool = true,
        mainThread: Bool = true
    ) -> Self {
        
        @Sendable
        func process() {
            onChange(self, tracking())
            
            if let shouldStop, shouldStop() {
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
        
        if useInitialValue {
            onChange(self, tracking())
        }
        
        _ = withObservationTracking({
            tracking()
        }, onChange: {
            process()
            onChange(self, tracking())
            if mainThread {
                Task.detached { @MainActor in
                    process()
                }
            } else {
                process()
            }
        })
        return self
    }
}

extension NSObject: ObservableNSObject {}


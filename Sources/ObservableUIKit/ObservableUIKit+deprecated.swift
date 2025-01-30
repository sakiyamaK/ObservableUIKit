//
//  ObservableUIKit+deprecated.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2025/01/30.
//

import UIKit

public extension ObservableUIKit {
    
    @available(*, deprecated, message: "observation is deprecated. Use tracking/trackingOptional instead")
    @MainActor
    @discardableResult
    func observation<T>(
        tracking: @escaping @Sendable @MainActor () -> T,
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
}

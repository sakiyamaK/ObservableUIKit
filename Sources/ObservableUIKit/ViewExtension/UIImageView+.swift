//  Created by sakiyamaK on 2023/10/05.
//

import UIKit.UIImageView

public extension UIImageView {
    
    typealias C = UIImageView

    @discardableResult
    func observation<T>(
        keyPath: ReferenceWritableKeyPath<C, T>,
        tracking: @escaping (() -> T),
        shouldStop: (() -> Bool)? = nil,
        useInitialValue: Bool = true
    ) -> Self {
        
        if useInitialValue {
            self[keyPath: keyPath] = tracking()
        }

        _ = withObservationTracking({
            tracking()
        }, onChange: {
            Task { @MainActor [weak self] in
                self?[keyPath: keyPath] = tracking()
                
                if let shouldStop, shouldStop() {
                    return
                }
                self?.observation(
                    keyPath: keyPath,
                    tracking: tracking,
                    shouldStop: shouldStop,
                    useInitialValue: false
                )
            }
        })
        return self
    }
    
    @discardableResult
    func observation<T>(
        keyPath: ReferenceWritableKeyPath<C, T?>,
        tracking: @escaping (() -> T?),
        shouldStop: (() -> Bool)? = nil,
        useInitialValue: Bool = true
    ) -> Self {

        if useInitialValue {
            self[keyPath: keyPath] = tracking()
        }

        _ = withObservationTracking({
            tracking()
        }, onChange: {
            Task { @MainActor [weak self] in
                self?[keyPath: keyPath] = tracking()
                
                if let shouldStop, shouldStop() {
                    return
                }
                self?.observation(
                    keyPath: keyPath,
                    tracking: tracking,
                    shouldStop: shouldStop,
                    useInitialValue: false
                )
            }
        })
        return self
    }
    
    @discardableResult
    func observation<T>(
        keyPath: ReferenceWritableKeyPath<C, T>,
        tracking: @escaping (() -> Void),
        onChange: @escaping (() -> T),
        shouldStop: (() -> Bool)? = nil,
        useInitialValue: Bool = true
    ) -> Self {

        if useInitialValue {
            self[keyPath: keyPath] = onChange()
        }

        withObservationTracking({
            tracking()
        }, onChange: {
            Task { @MainActor [weak self] in
                self?[keyPath: keyPath] = onChange()
                
                if let shouldStop, shouldStop() {
                    return
                }
                self?.observation(
                    keyPath: keyPath,
                    tracking: tracking,
                    onChange: onChange,
                    shouldStop: shouldStop,
                    useInitialValue: false
                )
            }
        })
        return self
    }
    
    @discardableResult
    func observation<T>(
        keyPath: ReferenceWritableKeyPath<C, T?>,
        tracking: @escaping (() -> Void),
        onChange: @escaping (() -> T?),
        shouldStop: (() -> Bool)? = nil,
        useInitialValue: Bool = true
    ) -> Self {

        if useInitialValue {
            self[keyPath: keyPath] = onChange()
        }

        withObservationTracking({
            tracking()
        }, onChange: {
            Task { @MainActor [weak self] in
                self?[keyPath: keyPath] = onChange()
                
                if let shouldStop, shouldStop() {
                    return
                }
                self?.observation(
                    keyPath: keyPath,
                    tracking: tracking,
                    onChange: onChange,
                    shouldStop: shouldStop,
                    useInitialValue: false
                )
            }
        })
        return self
    }
}

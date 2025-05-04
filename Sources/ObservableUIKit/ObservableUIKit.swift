//
//  ObservableNSObject.swift
//  ObservableUIKit
//
//  Created by sakiyamaK on 2024/12/27.
//

import UIKit

public protocol ObservableUIKit: AnyObject, Sendable {}
public extension ObservableUIKit {

    /// 指定されたクロージャが返す値を監視し、変更があるたびにコールバックを実行します。
    ///
    /// クロージャ `apply`、`onChange`、および `shouldStop` はすべてメインアクター (`@MainActor`) 上で実行されます。
    /// - Parameters:
    ///   - useInitialValue: `true` の場合、監視開始時に一度 `apply` を評価し、結果が非nilであれば
    ///     `onChange` を即座に呼び出します。デフォルトは `true` です。
    ///   - shouldStop: 監視を停止する条件を判定するクロージャ。`true` を返すと、それ以降の監視を停止します。
    ///     デフォルトでは常に `false` を返し、監視を継続します。
    ///   - apply: 監視対象の値 `T` を返すクロージャ。このクロージャ内でアクセスされる観測可能なプロパティが
    ///     追跡対象となります。`nil` を返した場合、監視が終了します。
    ///   - onChange: `apply` が返す値が変更された際に呼び出されるクロージャ。
    ///   第1引数に `self`、第2引数に `apply` が返した最新の非nil値 `T` が渡されます。
    ///
    /// - Returns: メソッドチェーンを可能にするために `self` を返します。
    @MainActor
    @discardableResult
    func tracking<T>(
        useInitialValue: Bool = true,
        shouldStop: @escaping (@MainActor () -> Bool) = { false },
        _ apply: @escaping @MainActor () -> T?,
        onChange: @escaping (@MainActor (Self, T) -> Void)
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
                    useInitialValue: false,
                    shouldStop: shouldStop,
                    apply,
                    onChange: onChange
                )
            }
        })
        
        return self
    }

    /// 指定されたクロージャが返すオプショナル値を監視し、変更があるたびにコールバックを実行します。
    /// これは tracking(useInitialValue:_ apply:sendOptional:shouldStop:_:onChange:)のオプショナル値対応版です。
    ///
    /// クロージャ `apply`、`onChange`、および `shouldStop` はすべてメインアクター (`@MainActor`) 上で実行されます。
    /// - Parameters:
    ///   - useInitialValue: `true` の場合、監視開始時に一度 `apply` を評価し、結果が非nilであれば
    ///     `onChange` を即座に呼び出します。デフォルトは `true` です。
    ///   - shouldStop: 監視を停止する条件を判定するクロージャ。`true` を返すと、それ以降の監視を停止します。
    ///     デフォルトでは常に `false` を返し、監視を継続します。
    ///   - apply: 監視対象の値 `T` を返すクロージャ。このクロージャ内でアクセスされる観測可能なプロパティが
    ///     追跡対象となります。
    ///   - onChange: `apply` が返す値が変更された際に呼び出されるクロージャ。
    ///   第1引数に `self`、第2引数に `apply` が返した最新の非nil値 `T` が渡されます。
    ///
    /// - Returns: メソッドチェーンを可能にするために `self` を返します。
    @MainActor
    @discardableResult
    func trackingOptional<T>(
        useInitialValue: Bool = true,
        shouldStop: @escaping (@MainActor () -> Bool) = { false },
        _ apply: @escaping @MainActor () -> T?,
        onChange: @escaping (@MainActor (Self, T?) -> Void)
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

                self.trackingOptional(
                    useInitialValue: false,
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

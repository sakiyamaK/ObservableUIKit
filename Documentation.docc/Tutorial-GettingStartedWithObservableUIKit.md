# Tutorial: Getting Started With ObservableUIKit

@Tutorials(ObservableUIKit)

## はじめに

このチュートリアルでは、ObservableUIKitを使ってUIButtonのタップイベントを監視する方法を学びます。

### ステップ 1: インポート

```swift
import ObservableUIKit
```

### ステップ 2: UIButtonの監視

```swift
let button = UIButton()
let cancellable = button.publisher(for: .touchUpInside)
    .sink { _ in
        print("ボタンがタップされました")
    }
```

## まとめ

このようにして、UIKitのイベントを簡単に監視できます。 
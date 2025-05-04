# ObservableUIKit

[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS_-yellowgreen?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![Twitter](https://img.shields.io/badge/twitter-@sakiyamaK-blue.svg?style=flat-square)](https://twitter.com/sakiyamaK)

UIKitのパラメータをObservation frameworkに対応させたライブラリです

Library to support Observation framework for UIKit parameters.


```swift
testView.tracking {[weak self] in
    self?.testData.cornerRadius
} onChange: { view, cornerRadius in
    view.layer.cornerRadius = cornerRadius
}.tracking {[weak self] in
    self?.testData.rotate
} onChange: { view, angle in
    view.transform = .init(rotationAngle: angle)
}.trackingOptional {[weak self] in
    self?.testData.color
} onChange: { view, color in
    view.backgroundColor = color
}
```


## Quick Start

```swift
import UIKit
import ObservableUIKit

// 監視対象のデータ
@Observable
final class TestData {
    var color: UIColor = .green
    var rotate: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var title: String?
}

final class ViewController: UIViewController {

    // 監視対象のデータ
    private var testData: TestData
    // 監視対象のプリミティブ型
    @UIKitState private var isLoading: Bool = true

    private let testView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()

    func track() {
        // UIViewの各パラメータを監視
        testView.tracking {[weak self] in
            self!.testData.cornerRadius
        } onChange: { view, cornerRadius in
            view.layer.cornerRadius = cornerRadius
        }.tracking {[weak self] in
            self!.testData.rotate
        } onChange: { view, angle in
            view.transform = .init(rotationAngle: angle)
        }.trackingOptional {[weak self] in
            self!.testData.color
        } onChange: { view, color in
            view.backgroundColor = color
        }

        // UIActivityIndicatorのパラメータを監視
        indicator.tracking {[weak self] in
            self!.isLoading
        } onChange: { indicator, loading in
            if loading {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }

    // 監視対象のデータを更新
    func update() {
        Task {
            try await Task.sleep(for: .seconds(2))
            isLoading = false

            try await Task.sleep(for: .seconds(1.0))
            testData.color = .red
            testData.title = "change 1"
        }
    }
}

```

* [Installation](#installation)
  * [Swift Package Manager](#swift-package-manager)

## Installation

### Swift Package Manager

Once you have your Swift package set up, adding ObservableUIKit as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/sakiyamaK/ObservableUIKit", .upToNextMajor(from: "3.0.0"))
]
```

To install ObservableUIKit package via Xcode

Go to File -> Swift Packages -> Add Package Dependency...
Then search for https://github.com/sakiyamaK/ObservableUIKit
And choose the version you want


## Document

https://sakiyamak.github.io/ObservableUIKit/documentation/observableuikit

## Tutorial

https://sakiyamak.github.io/ObservableUIKit/tutorials/tutorial-table-of-contents

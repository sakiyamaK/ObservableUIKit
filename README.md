# ObservableUIKit

[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS_-yellowgreen?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![Twitter](https://img.shields.io/badge/twitter-@sakiyamaK-blue.svg?style=flat-square)](https://twitter.com/sakiyamaK)

UIKitのパラメータをObservation frameworkに対応させたライブラリです

Library to support Observation framework for UIKit parameters.


```swift
import UIKit
import ObservableUIKit

@Observable
class TestData {
    var color: UIColor = .green
    var rotate: CGFloat = 0
    var cornerRadius: CGFloat = 0
    
    var title: String?
}

class ViewController: UIViewController {
    
    let testData = TestData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        track()
        update()
    }

    func track() {
        
        let testView: UIView = self.view.subviews.first!
        let testLabel: UILabel = self.view.subviews.first(where: { $0 is UILabel }) as! UILabel

        // UIViewの各パラメータを監視
        testView.observation(keyPath: \.backgroundColor) { [weak self] in
            self?.testData.color
        }.observation(keyPath: \.layer.cornerRadius) { [weak self] in
            self?.testData.cornerRadius ?? 0
        }.observation(keyPath: \.transform) { [weak self] in
            let angle = self?.testData.rotate ?? 0
            return .init(rotationAngle: angle)
        }
        
        // UILabelの各パラメータを監視
        testLabel.observation(keyPath: \.text) { [weak self] in
            self?.testData.title ?? "default"
        }.observation(keyPath: \.textColor) { [weak self] in
            self?.testData.color
        }.observation(keyPath: \UILabel.backgroundColor) { [weak self] in
            self?.testData.color
        }
    }
    
    // 監視対象のデータを更新
    func update() {
        Task {
            try await Task.sleep(for: .seconds(1.0))
            testData.color = .red
            testData.title = "change 1"

            try await Task.sleep(for: .seconds(1.0))
            testData.color = .blue
            testData.rotate = 10.0 * 180.0 / Double.pi
            testData.cornerRadius = 20
            testData.title = "change 2"
            
            try await Task.sleep(for: .seconds(1.0))
            testData.color = .black
            testData.rotate = 20.0 * 180.0 / Double.pi
            testData.cornerRadius = 30
            testData.title = "change 3"

            try await Task.sleep(for: .seconds(1.0))
            testData.color = .red
            testData.cornerRadius = 50
            testData.title = "change 4"

        }
    }

    func layout() {
        let testView = UIView(frame: .zero)
        
        self.view.addSubview(testView)
        
        testView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testView.widthAnchor.constraint(equalToConstant: 100),
            testView.heightAnchor.constraint(equalToConstant: 100),
            testView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            testView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])

        let testLabel = UILabel(frame: .zero)
        
        self.view.addSubview(testLabel)
        
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testLabel.heightAnchor.constraint(equalToConstant: 100),
            testLabel.centerXAnchor.constraint(equalTo: testView.centerXAnchor),
            testLabel.topAnchor.constraint(equalTo: testView.bottomAnchor, constant: 20)
        ])
    }    
}


```

* [Installation](#installation)
  * [Swift Package Manager](#swift-package-manager)
  * [CocoaPods](#cocoapods)

## Installation

### Swift Package Manager

Once you have your Swift package set up, adding ObservableUIKit as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/sakiyamaK/ObservableUIKit", .upToNextMajor(from: "0.0.3"))
]
```

To install ObservableUIKit package via Xcode

Go to File -> Swift Packages -> Add Package Dependency...
Then search for https://github.com/sakiyamaK/ObservableUIKit
And choose the version you want

### CocoaPods

~~[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate ObservableUIKit into your Xcode project using CocoaPods, specify it in your `Podfile`:~~

~~```ruby~~
~~pod 'SKObservableUIKit'~~
~~```~~

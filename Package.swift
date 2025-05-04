// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ObservableUIKit",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "ObservableUIKit",
            targets: ["ObservableUIKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "ObservableUIKit",
            path: "Sources"
        ),
        .testTarget(
            name: "ObservableUIKitTests",
            dependencies: ["ObservableUIKit"]),
    ]
)

// swift-tools-version: 5.9
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
    targets: [
        .target(name: "ObservableUIKit", path: "Sources"),
        .testTarget(
            name: "ObservableUIKitTests",
            dependencies: ["ObservableUIKit"]),
    ]
)

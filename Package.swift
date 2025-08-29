// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "QCartSDK", // internal package name
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "QCartSDK",
            targets: ["QCartSDK"]
        )
    ],
    targets: [
        .target(
            name: "QCartSDK",
            path: "Sources/QCartSDK"
        ),
        .testTarget(
            name: "QCartSDKTests",
            dependencies: ["QCartSDK"],
            path: "Tests/QCartSDKTests"
        )
    ]
)
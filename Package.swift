// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "QcartSDK", // internal package name
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "QcartSDK",
            targets: ["QcartSDK"]
        )
    ],
    targets: [
        .target(
            name: "QcartSDK",
            path: "Sources/QcartSDK"
        ),
        .target(
            name: "QcartTestAppLogic",
            dependencies: ["QcartSDK"]
        ),
        .target(
            name: "QcartTestAppSwiftUI",
            dependencies: ["QcartTestAppLogic"]
        ),
        .executableTarget(
            name: "QcartTestAppCLI",
            dependencies: ["QcartTestAppLogic"]
        )
    ]
)
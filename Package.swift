// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "QcartSDK",
    platforms: [.iOS(.v13)],
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
        // Keep UI apps as library targets (run via Xcode)
        .target(
            name: "QcartTestAppSwiftUI",
            dependencies: ["QcartTestAppLogic"],
            path: "Sources/QcartTestAppSwiftUI"
        ),
        .target(
            name: "QcartTestAppUIKit",
            dependencies: ["QcartTestAppLogic"],
            path: "Sources/QcartTestAppUIKit"
        ),
        // CLI app remains executable
        .executableTarget(
            name: "QcartTestAppCLI",
            dependencies: ["QcartTestAppLogic"]
        )
    ]
)
// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "QcartSDK",
    defaultLocalization: "en",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "QcartSDK",
            targets: ["QcartSDK"]
        )
    ],
    targets: [
        // SDK library
        .target(
            name: "QcartSDK",
            path: "Sources/QcartSDK"
        ),
        // Shared logic library
        .target(
            name: "QcartTestAppLogic",
            dependencies: ["QcartSDK"],
            path: "Sources/QcartTestAppLogic"
        ),
        // SwiftUI app
        .executableTarget(
            name: "QcartTestAppSwiftUI",
            dependencies: ["QcartTestAppLogic"],
            path: "Sources/QcartTestAppSwiftUI"
        ),
        // UIKit app
        .executableTarget(
            name: "QcartTestAppUIKit",
            dependencies: ["QcartTestAppLogic"],
            path: "Sources/QcartTestAppUIKit"
        ),
        // CLI app remains executable
        .executableTarget(
            name: "QcartTestAppCLI",
            dependencies: ["QcartTestAppLogic"],
            path: "Sources/QcartTestAppCLI"
        )
    ]
)
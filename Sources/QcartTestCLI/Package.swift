// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "QcartTestCLI",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(path: "../../") // relative path to the SDK folder
        // .package(url: "https://github.com/comoquiero/qcart-sdk-ios.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "QcartTestCLI",
            dependencies: [
                .product(name: "QcartSDK", package: "qcart-sdk-ios")
            ]
        )
    ]
)
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "QCartTestCLI",
    platforms: [.macOS(.v12)],
    dependencies: [
        // .package(path: "../../") // relative path to the SDK folder
        .package(url: "https://github.com/comoquiero/qcart-sdk-ios.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "QCartTestCLI",
            dependencies: [
                .product(name: "QCartSDK", package: "qcart-sdk-ios")
            ]
        )
    ]
)
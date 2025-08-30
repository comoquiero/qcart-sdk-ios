// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "QCartTestApp",
    platforms: [
        .iOS(.v13)  // or macOS if desired
    ],
    dependencies: [
        // Reference your SDK from GitHub
        // .package(path: "../../") // relative path to the SDK folder
        .package(url: "https://github.com/comoquiero/qcart-sdk-ios.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "QCartTestApp",
            dependencies: [
                .product(name: "QCartSDK", package: "qcart-sdk-ios")
            ]            
        )
    ]
)

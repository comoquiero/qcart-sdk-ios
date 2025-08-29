# QCart SDK

iOS SDK for handling QCart deep links.

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/comoquiero/qcart-sdk-ios.git", from: "1.0.0")
]
```

## Tests

### Test SDK from command line

```
cd Tests/QCartTestCLI
swift package clean
rm -rf .build
swift run
```

### Test SDK from App

```
cd Tests/QCartTestApp
swift package clean
rm -rf .build
swift run

// You can trigger deep links using:
xcrun simctl openurl booted "qcart://deeplink?qcart=true&skus=sku1:2,sku2:5"

```

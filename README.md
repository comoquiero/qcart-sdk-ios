# Qcart SDK

iOS SDK for handling Qcart deep links.

## Installation

### Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/comoquiero/qcart-sdk-ios.git", from: "1.0.0")
]
```

## Tests

Open the workspace
```
open -a Xcode QcartSDK.xcworkspace
```

### Test SDK from command line
```
swift run QcartTestAppCLI
```

### Test SDK from App

#### SwiftUI
- Open repo in Xcode
- Select target Sources/QcartTestAppSwiftUI
- Run

#### UIKit
- Open repo in Xcode
- Select target Sources/QcartTestAppUIKit
- Run

#### Deeplink
You can trigger deep links using:
```
xcrun simctl openurl booted "https://test.abc/path/name?qcart=true&skus=111,222:3#hashparam=123"
```
// swift run

import Foundation
import QcartSDK

// Example deeplink URL
let deeplinkURL = URL(string: "https://test.abc/path/name?qcart=true&skus=111,222:3#hashparam=123")!

let result = QcartParser.handle(url: deeplinkURL)

// Print all parts (like iOS app would)
print("url: \(result.url ?? "")\n")
print("pathSegments: \(result.pathSegments)\n")
print("queryParameters: \(result.queryParameters)\n")
print("fragmentParameters: \(result.fragmentParameters)\n")
print("isQcart: \(result.isQcart)\n")
print("skus: [\(result.skus.map { "{\"sku\":\"\($0.sku)\",\"quantity\":\($0.quantity)}" }.joined(separator: ","))]\n")
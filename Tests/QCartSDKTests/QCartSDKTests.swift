import XCTest
@testable import QCartSDK

final class QCartSDKTests: XCTestCase {

    func testDeeplinkParsing() {
        let url = URL(string: "myapp://deeplink?skus=sku1:2,sku2:5")!

        var received: [(String, Int)] = []

        QcartDeeplink.handle(url: url) { skuList in
            received = skuList
        }

        XCTAssertEqual(received.count, 2)
        XCTAssertEqual(received[0].0, "sku1")
        XCTAssertEqual(received[0].1, 2)
        XCTAssertEqual(received[1].0, "sku2")
        XCTAssertEqual(received[1].1, 5)
    }
}
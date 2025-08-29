import Foundation
import QCartSDK

let url1 = URL(string: "https://test.abc?qcart=true&skus=sku1:2,sku2:5")!
let url2 = URL(string: "https://test.abc?skus=sku1:2,sku2:5")!

QcartDeeplink.handle(url: url1) { skus in
    print("URL1 SKUs:", skus)  // Will print
}

QcartDeeplink.handle(url: url2) { skus in
    print("URL2 SKUs:", skus)  // Will NOT print
}
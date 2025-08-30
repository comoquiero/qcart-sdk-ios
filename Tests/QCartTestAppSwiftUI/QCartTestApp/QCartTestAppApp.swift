import SwiftUI
import QCartSDK

@main
struct QCartTestApp: App {
    @StateObject var deeplinkData = DeeplinkData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deeplinkData)
                .onOpenURL { url in
                    // Pass all URLs to the SDK
                    DeeplinkManager.shared.handle(url: url) { result in
                        DispatchQueue.main.async {

                            if let qcart = result.qcart, !qcart.skus.isEmpty {
                                self.handleQCartSkus(qcart.skus) //QCart SKUs exist → handle them
                                return;
                            }

                            // No QCart SKUs → handle non-QCart links
                            print("Handle non-QCart deeplink:", url.absoluteString)
                            // [...]
                        }
                    }
                }
        }
    }

    private func handleQCartSkus(_ skus: [(String, Int)]) {
        // Example: fill cart
        // CartManager.shared.fillCart(with: skus)

        // Update state for UI
        deeplinkData.skus = skus
    }
}

class DeeplinkData: ObservableObject {
    @Published var skus: [(String, Int)] = []
}
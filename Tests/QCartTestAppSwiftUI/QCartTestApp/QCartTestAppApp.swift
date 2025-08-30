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
                    Task { @MainActor in
                        // Call the async handle method with await
                        let result = await DeeplinkManager.shared.handle(url: url)

                        // Handle QCart SKUs if available
                        if let qcart = result.qcart, !qcart.skus.isEmpty {
                            self.handleQCartSkus(qcart.skus)
                            return
                        }

                        // No QCart SKUs → handle non-QCart links
                        print("Handle non-QCart deeplink:", url.absoluteString)
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
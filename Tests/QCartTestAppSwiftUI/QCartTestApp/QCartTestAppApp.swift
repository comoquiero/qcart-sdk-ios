import SwiftUI
import QCartSDK

@main
struct QCartTestAppApp: App {
    @StateObject var deeplinkData = DeeplinkData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deeplinkData)
                .onOpenURL { url in
                    QcartDeeplink.handle(url: url) { skus in
                        DispatchQueue.main.async {
                            deeplinkData.skus = skus
                        }
                    }
                }
        }
    }
}

class DeeplinkData: ObservableObject {
    @Published var skus: [(String, Int)] = []
}
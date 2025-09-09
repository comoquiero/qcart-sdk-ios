import SwiftUI
import QcartSDK
import QcartTestAppLogic

@main
struct QcartTestApp: App {
    @StateObject private var deeplinkResult = DeeplinkResult()
    private let qcartHandler = QcartHandler()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deeplinkResult)
                .onOpenURL { url in
                    qcartHandler.handle(url: url, deeplinkResult: deeplinkResult)
                }
        }
    }
}
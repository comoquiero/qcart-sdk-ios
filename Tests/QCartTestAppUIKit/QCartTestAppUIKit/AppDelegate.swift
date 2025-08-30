import UIKit
import QCartSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()

        // Handle URL if app launched via deeplink
        if let url = launchOptions?[.url] as? URL {
            handleIncomingDeeplink(url: url)
        }

        return true
    }

    // MARK: - Custom URL scheme (simulator)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleIncomingDeeplink(url: url)
        return true
    }

    // MARK: - Universal Links (real device)
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }

        handleIncomingDeeplink(url: url)
        return true
    }

    // MARK: - Private helpers
    private func handleIncomingDeeplink(url: URL) {
        DeeplinkManager.shared.handle(url: url) { result in
            Task { @MainActor in
                // Handle QCart SKUs if available
                if let qcart = result.qcart, !qcart.skus.isEmpty {
                    self.handleQCartSkus(qcart.skus)
                    return
                }

                // Fallback for non-QCart links
                print("Handle non-QCart deeplink:", url.absoluteString)
            }
        }
    }

    private func handleQCartSkus(_ skuList: [(String, Int)]) {
        // Example: add SKUs to the cart
        // CartManager.shared.fillCart(with: skuList)

        // Update UI if root is ViewController
        if let vc = self.window?.rootViewController as? ViewController {
            vc.updateSkus(skus: skuList)
        }
    }
}
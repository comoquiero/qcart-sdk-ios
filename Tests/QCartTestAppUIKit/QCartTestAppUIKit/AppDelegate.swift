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

        // Initialize SDK callback
        DeeplinkManager.shared.initManager { result in
            DispatchQueue.main.async {

                if let qcart = result?.qcart, !qcart.skus.isEmpty {
                    self.handleQCartSkus(qcart.skus) //QCart SKUs exist → handle them
                    return;
                }
                
                // No QCart SKUs → Normal app startup logic (home screen, load defaults, etc.)
                if let vc = self.window?.rootViewController as? ViewController {
                    vc.loadDefaultContent()
                }
            }
        }

        return true
    }

    // Custom URL scheme (simulator)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleIncomingDeeplink(url: url)
        return true
    }

    // Universal Links (real device)
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
            DispatchQueue.main.async {

                if let qcart = result?.qcart, !qcart.skus.isEmpty {
                    self.handleQCartSkus(qcart.skus) //QCart SKUs exist → handle them
                    return;
                }
                
                // No QCart SKUs → Handle non-QCart links (custom scheme / universal link)
                print("Handle non-QCart deeplink:", url.absoluteString)
                DeeplinkManager.shared.handle(url: url) // optional if SDK has other logic
            }
        }
    }

    private func handleQCartSkus(_ skuList: [(String, Int)]) {
        // Example: fill cart
        // CartManager.shared.fillCart(with: skuList)

        // Update UI if root is ViewController
        if let vc = self.window?.rootViewController as? ViewController {
            vc.updateSkus(skus: skuList)
        }
    }
}
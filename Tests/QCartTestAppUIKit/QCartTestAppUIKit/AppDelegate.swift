import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        // ✅ Create window and assign to self.window
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // ✅ Root view controller
        let vc = ViewController()
        let navController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()

        // ✅ Initialize SDK callback
        DeeplinkManager.shared.initManager { skuList in
            DispatchQueue.main.async {
                vc.updateSkus(skus: skuList)
            }
        }

        return true
    }

    // Custom URL scheme (for simulator testing)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        handleQcartDeeplink(url: url)
        return true
    }

    // Universal Links (real device)
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }

        handleQcartDeeplink(url: url)
        return true
    }

    private func handleQcartDeeplink(url: URL) {
        // SDK parses qcart=true and SKUs
        QcartDeeplink.handle(url: url) { skuList in
            DispatchQueue.main.async {
                if let vc = self.window?.rootViewController as? ViewController {
                    vc.updateSkus(skus: skuList)
                }
            }
        }

        // Notify DeeplinkManager
        DeeplinkManager.shared.handle(url: url)
    }
}
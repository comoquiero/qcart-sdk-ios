import UIKit
import QCartSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        // Create window
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        // Root view controller
        let vc = ViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()

        // SDK init callback
        DeeplinkManager.shared.initManager { skuList in
            DispatchQueue.main.async {
                vc.updateSkus(skus: skuList)
            }
        }

        return true
    }

    // Custom URL scheme (temporary for simulator)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        handleQcartDeeplink(url: url)
        return true
    }

    // Universal Links
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }

        handleQcartDeeplink(url: url)
        return true
    }

    private func handleQcartDeeplink(url: URL) {
        QcartDeeplink.handle(url: url) { skuList in
            DispatchQueue.main.async {
                if let vc = self.window?.rootViewController as? ViewController {
                    vc.updateSkus(skus: skuList)
                }
            }
        }

        DeeplinkManager.shared.handle(url: url)
    }
}
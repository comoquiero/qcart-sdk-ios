import UIKit
import QCartSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        // Initialize SDK; this will provide a list of already captured domains
        DeeplinkManager.shared.initManager { skuList in
            vc.updateSkus(skus: skuList)
        }

        return true
    }

    // MARK: - Handle Custom URL Scheme (temporary for simulator)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        handleQcartDeeplink(url: url)
        return true
    }

    // MARK: - Handle Universal Links
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }

        handleQcartDeeplink(url: url)
        return true
    }

    // MARK: - Shared logic for handling qcart=true
    private func handleQcartDeeplink(url: URL) {
        // Only process links with qcart=true
        QcartDeeplink.handle(url: url) { skuList in
            if let vc = self.window?.rootViewController as? ViewController {
                vc.updateSkus(skus: skuList)
            }
        }

        // Notify SDK if needed
        DeeplinkManager.shared.handle(url: url)
    }
}
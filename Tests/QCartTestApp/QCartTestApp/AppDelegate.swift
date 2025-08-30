import UIKit
import QCartSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?  // must be declared here

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        // 1️⃣ Create the window
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        // 2️⃣ Set the root view controller
        let vc = ViewController()
        window.rootViewController = vc

        // 3️⃣ Make it visible
        window.makeKeyAndVisible()

        // 4️⃣ Initialize SDK callback (optional)
        DeeplinkManager.shared.initManager { skuList in
            DispatchQueue.main.async {
                vc.updateSkus(skus: skuList)
            }
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
            DispatchQueue.main.async {
                if let vc = self.window?.rootViewController as? ViewController {
                    vc.updateSkus(skus: skuList)
                }
            }
        }

        DeeplinkManager.shared.handle(url: url)
    }
}
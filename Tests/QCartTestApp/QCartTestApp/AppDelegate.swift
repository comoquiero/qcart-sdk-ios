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

        // Initialize SDK (optional, for internal setup)
        DeeplinkManager.shared.initManager { skuList in
            vc.updateSkus(skus: skuList)
        }

        return true
    }

    // Only handle Universal Links that the client app already opens
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }

        // Only process if the client app has opened this URL
        // SDK only filters by qcart=true
        QcartDeeplink.handle(url: url) { skuList in
            if let vc = self.window?.rootViewController as? ViewController {
                vc.updateSkus(skus: skuList)
            }
        }

        return true
    }
}
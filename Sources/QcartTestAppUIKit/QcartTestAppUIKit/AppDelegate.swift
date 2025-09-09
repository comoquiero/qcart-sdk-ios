import UIKit
import QcartSDK
import QcartTestAppLogic

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let qcartHandler = QcartHandler()
    private let deeplinkResult = DeeplinkResult()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ViewController()
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()

        if let url = launchOptions?[.url] as? URL {
            handle(url: url)
        }

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        handle(url: url)
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return false }
        handle(url: url)
        return true
    }

    // MARK: - Private helper
    private func handle(url: URL) {
        qcartHandler.handle(url: url, deeplinkResult: deeplinkResult)

        if let nav = window?.rootViewController as? UINavigationController,
           let vc = nav.viewControllers.first as? ViewController {
            vc.updateTextView(with: deeplinkResult.fullResult)
        }
    }
}
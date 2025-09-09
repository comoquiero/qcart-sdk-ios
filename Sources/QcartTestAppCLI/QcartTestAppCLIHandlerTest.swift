import Foundation
import QcartSDK
import QcartTestAppLogic

@main
struct QcartCLIMain {

    static func main() {
        Task { @MainActor in
            let deeplinkResult = DeeplinkResult()
            let qcartHandler = QcartHandler()

            let urls = [
                "https://test.abc/path/name?qcart=true&skus=111,222:3#hashparam=123"
            ]

            for urlString in urls {
                guard let url = URL(string: urlString) else { continue }
                qcartHandler.handle(url: url, deeplinkResult: deeplinkResult)
            }

            exit(0)
        }

        RunLoop.main.run()
    }
}
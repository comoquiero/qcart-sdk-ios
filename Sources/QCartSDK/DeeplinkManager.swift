import Foundation

public class DeeplinkManager {

    public typealias SkusCallback = ([(String, Int)]) -> Void

    public static let shared = DeeplinkManager()
    private var callback: SkusCallback?

    private init() {}

    public func initManager(callback: @escaping SkusCallback) {
        self.callback = callback
    }

    public func handle(url: URL?) {
        QcartDeeplink.handle(url: url) { skuList in
            self.callback?(skuList)
        }
    }

    public func clear() {
        self.callback = nil
    }
}
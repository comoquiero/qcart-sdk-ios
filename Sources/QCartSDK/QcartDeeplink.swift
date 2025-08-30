import Foundation

// MARK: - DeeplinkManager

@MainActor
public class DeeplinkManager {

    public static let shared = DeeplinkManager()

    private init() {}

    /// Called once at app launch to check if app was launched via deeplink
    public func initManager(onResult: @Sendable @escaping (DeeplinkResult) -> Void) {
        if let launchURL = getPendingLaunchURL() {
            QcartDeeplink.handle(url: launchURL) { skus in
                Task { @MainActor in
                    let result = DeeplinkResult(qcart: DeeplinkResult.QCart(skus: skus))
                    onResult(result)
                }
            }
        }
    }

    /// Called whenever a URL arrives (custom scheme / universal link)
    public func handle(url: URL, _ onResult: @escaping (DeeplinkResult) -> Void) {
        QcartDeeplink.handle(url: url) { skus in
            Task { @MainActor in
                let result = DeeplinkResult(qcart: DeeplinkResult.QCart(skus: skus))
                onResult(result)
            }
        }
    }

    // Example: simulate a launch URL (SDK internal)
    private func getPendingLaunchURL() -> URL? {
        return nil
    }
}

// MARK: - DeeplinkResult

public struct DeeplinkResult {
    public struct QCart {
        public let skus: [(String, Int)]
    }
    public let qcart: QCart?
}

// MARK: - QcartDeeplink

public struct QcartDeeplink {

    // Parse a URL for qcart SKUs and call the closure if any are found
    public static func handle(url: URL?, onSkus: @escaping ([(String, Int)]) -> Void) {
        guard let url = url else { return }

        guard let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
            return
        }

        // Only proceed if qcart=true is present
        guard let qcartValue = queryItems.first(where: { $0.name == "qcart" })?.value,
              qcartValue.lowercased() == "true" else {
            return
        }

        // Parse skus
        guard let skusParam = queryItems.first(where: { $0.name == "skus" })?.value else {
            return
        }

        let skuQuantities: [(String, Int)] = skusParam.split(separator: ",").compactMap { pairStr in
            let parts = pairStr.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2, let quantity = Int(parts[1]), !parts[0].isEmpty {
                return (String(parts[0]), quantity)
            } else {
                return nil
            }
        }

        if !skuQuantities.isEmpty {
            onSkus(skuQuantities)
        }
    }
}
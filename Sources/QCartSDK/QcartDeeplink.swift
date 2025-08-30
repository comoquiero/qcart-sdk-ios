import Foundation

// MARK: - DeeplinkManager

@MainActor
public class DeeplinkManager {

    public static let shared = DeeplinkManager()

    private init() {}

    // MARK: - Async API (modern Swift)
    @MainActor
    public func handle(url: URL) async -> DeeplinkResult {
        await withCheckedContinuation { continuation in
            QcartDeeplink.handle(url: url) { skus in
                let result = DeeplinkResult(qcart: DeeplinkResult.QCart(skus: skus))
                continuation.resume(returning: result)
            }
        }
    }

    // MARK: - Completion handler API (backward compatibility)
    public func handle(url: URL, completion: @escaping (DeeplinkResult) -> Void) {
        Task {
            let result = await handle(url: url)
            completion(result)
        }
    }

    /// Called once at app launch to check if app was launched via deeplink
    public func initManager(completion: @escaping (DeeplinkResult) -> Void) {
        if let launchURL = getPendingLaunchURL() {
            handle(url: launchURL, completion: completion)
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

        // Parse SKUs (format: sku1:2,sku2:3)
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
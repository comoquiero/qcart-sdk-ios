import Foundation

public struct QcartDeeplink {

    public static func handle(url: URL?, onSkus: ([(String, Int)]) -> Void) {
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
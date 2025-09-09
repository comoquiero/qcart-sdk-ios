import Foundation

// MARK: - QcartManager

@MainActor
public class QcartManager {

    public init() {}

    /// Handle a URL and return a full QcartResult
    public func handle(url: URL) -> QcartResult {
        return QcartParser.handle(url: url)
    }

    /// Called once at app launch to check if app was launched via URL
    public func initManager() -> QcartResult? {
        guard let launchURL = getPendingLaunchURL() else { return nil }
        return handle(url: launchURL)
    }

    private func getPendingLaunchURL() -> URL? {
        return nil
    }
}

// MARK: - QcartResult

public struct QcartResult: Codable {
    public let url: String?
    public let pathSegments: [String]
    public let queryParameters: [String: String]
    public let fragmentParameters: [String: String]
    public let isQcart: Bool
    public let skus: [QcartSKU]

    public init(
        url: String?,
        pathSegments: [String],
        queryParameters: [String: String],
        fragmentParameters: [String: String],
        isQcart: Bool,
        skus: [QcartSKU]
    ) {
        self.url = url
        self.pathSegments = pathSegments
        self.queryParameters = queryParameters
        self.fragmentParameters = fragmentParameters
        self.isQcart = isQcart
        self.skus = skus
    }
    
    /// Convert to JSON for easy Flutter consumption
    public func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - SKU Struct

public struct QcartSKU: Codable {
    public let sku: String
    public let quantity: Int
    
    public init(sku: String, quantity: Int) {
        self.sku = sku
        self.quantity = quantity
    }
}

// MARK: - QcartParser

public struct QcartParser {

    public static func handle(url: URL?) -> QcartResult {
        guard let url = url else {
            return QcartResult(
                url: nil,
                pathSegments: [],
                queryParameters: [:],
                fragmentParameters: [:],
                isQcart: false,
                skus: []
            )
        }

        // Parse query parameters
        var queryParams: [String: String] = [:]
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let items = components.queryItems {
            for item in items {
                queryParams[item.name] = item.value ?? ""
            }
        }

        // Parse fragment parameters
        var fragmentParams: [String: String] = [:]
        if let fragment = url.fragment {
            for pair in fragment.split(separator: "&") {
                let parts = pair.split(separator: "=", maxSplits: 1).map { String($0) }
                if parts.count == 2 {
                    fragmentParams[parts[0]] = parts[1]
                }
            }
        }

        // Merge query & fragment params
        let combinedParams = queryParams.merging(fragmentParams) { current, _ in current }

        // Parse SKUs
        let skus: [QcartSKU]
        if let skusParam = combinedParams["skus"] {
            skus = skusParam.split(separator: ",").compactMap { pair in
                let parts = pair.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
                if parts.count == 2, let quantity = Int(parts[1]), !parts[0].isEmpty {
                    return QcartSKU(sku: String(parts[0]), quantity: quantity)
                } else if parts.count == 1, !parts[0].isEmpty {
                    return QcartSKU(sku: String(parts[0]), quantity: 1)
                } else {
                    return nil
                }
            }
        } else {
            skus = []
        }

        // Path segments
        let pathSegments = url.pathComponents.filter { $0 != "/" }

        // Check if qcart=true exists
        let isQcart = (queryParams["qcart"]?.lowercased() == "true") || (fragmentParams["qcart"]?.lowercased() == "true")

        return QcartResult(
            url: url.absoluteString,
            pathSegments: pathSegments,
            queryParameters: queryParams,
            fragmentParameters: fragmentParams,
            isQcart: isQcart,
            skus: skus
        )
    }
}
import Foundation
import QcartSDK

public class DeeplinkResult: ObservableObject {
    @Published public var fullResult: String = ""
    public init() {}
}

@MainActor
public class QcartHandler {

    private let qcartManager: QcartManager

    public init(qcartManager: QcartManager = QcartManager()) {
        self.qcartManager = qcartManager
    }

    public func handle(url: URL, deeplinkResult: DeeplinkResult) {
        // All work runs on MainActor; no Sendable needed
        let result = qcartManager.handle(url: url)
        let fullResult = """
        url: \(result.url ?? "")
        pathSegments: \(result.pathSegments)
        queryParameters: \(result.queryParameters)
        fragmentParameters: \(result.fragmentParameters)
        isQcart: \(result.isQcart)
        skus: [\(result.skus.map { "{\"sku\":\"\($0.sku)\",\"quantity\":\($0.quantity)}" }.joined(separator: ","))]
        """
        deeplinkResult.fullResult = fullResult
        print(fullResult)
    }
}
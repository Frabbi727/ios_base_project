import Foundation
import os.log

class AppLogger {
    static let shared = AppLogger()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.demo.app", category: "AppLogger")
    
    private init() {}
    
    func log(_ message: String, level: LogLevel = .info) {
        switch level {
        case .debug:
            logger.debug("\(message)")
        case .info:
            logger.info("\(message)")
        case .warning:
            logger.warning("\(message)")
        case .error:
            logger.error("\(message)")
        case .critical:
            logger.critical("\(message)")
        }
    }
    
    func logNetworkRequest(_ request: URLRequest) {
        log("📡 Network Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "Unknown URL")", level: .info)
    }
    
    func logNetworkResponse(_ response: URLResponse?, data: Data?) {
        if let httpResponse = response as? HTTPURLResponse {
            log("📡 Network Response: \(httpResponse.statusCode) - \(data?.count ?? 0) bytes", level: .info)
        }
    }
    
    func logError(_ error: Error, context: String = "") {
        log("❌ Error \(context): \(error.localizedDescription)", level: .error)
    }
}

enum LogLevel {
    case debug
    case info
    case warning
    case error
    case critical
}
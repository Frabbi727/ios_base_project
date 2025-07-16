import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkFailure(Error)
    case invalidResponse
    case serverError(Int)
    case timeout
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkFailure(let error):
            return "Network failure: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .timeout:
            return "Request timeout"
        case .noInternetConnection:
            return "No internet connection"
        }
    }
}
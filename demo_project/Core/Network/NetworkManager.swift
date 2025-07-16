import Foundation
import Combine

protocol NetworkManagerProtocol {
    func request<T: Codable>(_ endpoint: String, method: String, parameters: [String: Any]?) -> AnyPublisher<T, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConstants.timeout
        config.timeoutIntervalForResource = APIConstants.timeout
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(_ endpoint: String, method: String = APIConstants.HTTPMethods.get, parameters: [String: Any]? = nil) -> AnyPublisher<T, NetworkError> {
        
        guard let url = URL(string: APIConstants.baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                return Fail(error: NetworkError.networkFailure(error))
                    .eraseToAnyPublisher()
            }
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.serverError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError
                } else if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.networkFailure(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
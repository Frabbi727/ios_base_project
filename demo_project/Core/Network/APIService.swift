import Foundation
import Combine

protocol APIServiceProtocol {
    func getUsers() -> AnyPublisher<[User], NetworkError>
    func getUser(id: Int) -> AnyPublisher<User, NetworkError>
    func getPosts() -> AnyPublisher<[Post], NetworkError>
    func getUserPosts(userId: Int) -> AnyPublisher<[Post], NetworkError>
}

class APIService: APIServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func getUsers() -> AnyPublisher<[User], NetworkError> {
        return networkManager.request(APIConstants.Endpoints.users)
    }
    
    func getUser(id: Int) -> AnyPublisher<User, NetworkError> {
        let endpoint = APIConstants.Endpoints.user.replacingOccurrences(of: "{id}", with: "\(id)")
        return networkManager.request(endpoint)
    }
    
    func getPosts() -> AnyPublisher<[Post], NetworkError> {
        return networkManager.request(APIConstants.Endpoints.posts)
    }
    
    func getUserPosts(userId: Int) -> AnyPublisher<[Post], NetworkError> {
        let endpoint = APIConstants.Endpoints.userPosts.replacingOccurrences(of: "{id}", with: "\(userId)")
        return networkManager.request(endpoint)
    }
}
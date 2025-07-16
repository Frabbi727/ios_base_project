import Foundation
import Combine

protocol ProfileViewModelProtocol: ObservableObject {
    var user: User? { get }
    var userPosts: [Post] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
    
    func loadUser(id: Int)
    func loadUserPosts(userId: Int)
}

class ProfileViewModel: BaseViewModel, ProfileViewModelProtocol {
    @Published var user: User?
    @Published var userPosts: [Post] = []
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = DIContainer.shared.resolve(APIServiceProtocol.self)) {
        self.apiService = apiService
        super.init()
    }
    
    func loadUser(id: Int) {
        startLoading()
        
        apiService.getUser(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.stopLoading()
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] user in
                    self?.user = user
                    self?.loadUserPosts(userId: user.id)
                }
            )
            .store(in: &cancellables)
    }
    
    func loadUserPosts(userId: Int) {
        apiService.getUserPosts(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] posts in
                    self?.userPosts = posts
                }
            )
            .store(in: &cancellables)
    }
}
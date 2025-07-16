import Foundation
import Combine

protocol HomeViewModelProtocol: ObservableObject {
    var users: [User] { get }
    var posts: [Post] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var showError: Bool { get }
    
    func loadUsers()
    func loadPosts()
    func refresh()
}

class HomeViewModel: BaseViewModel, HomeViewModelProtocol {
    @Published var users: [User] = []
    @Published var posts: [Post] = []
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = DIContainer.shared.resolve(APIServiceProtocol.self)) {
        self.apiService = apiService
        super.init()
        loadUsers()
        loadPosts()
    }
    
    func loadUsers() {
        startLoading()
        
        apiService.getUsers()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.stopLoading()
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] users in
                    self?.users = users
                }
            )
            .store(in: &cancellables)
    }
    
    func loadPosts() {
        apiService.getPosts()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] posts in
                    self?.posts = posts
                }
            )
            .store(in: &cancellables)
    }
    
    func refresh() {
        users.removeAll()
        posts.removeAll()
        loadUsers()
        loadPosts()
    }
}
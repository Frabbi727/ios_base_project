import Foundation

protocol DIContainerProtocol {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func resolve<T>(_ type: T.Type) -> T
}

class DIContainer: DIContainerProtocol {
    static let shared = DIContainer()
    
    private var factories: [String: () -> Any] = [:]
    
    private init() {}
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let factory = factories[key] else {
            fatalError("No factory registered for type \(type)")
        }
        return factory() as! T
    }
}

extension DIContainer {
    func setupDependencies() {
        register(APIServiceProtocol.self) {
            APIService()
        }
        
        register(HomeViewModelProtocol.self) {
            HomeViewModel(apiService: self.resolve(APIServiceProtocol.self))
        }
        
        register(ProfileViewModelProtocol.self) {
            ProfileViewModel(apiService: self.resolve(APIServiceProtocol.self))
        }
    }
}
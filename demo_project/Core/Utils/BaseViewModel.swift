import Foundation
import Combine

class BaseViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    var cancellables = Set<AnyCancellable>()
    
    func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.isLoading = false
            if let networkError = error as? NetworkError {
                self.errorMessage = networkError.errorDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
            self.showError = true
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.showError = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    deinit {
        cancellables.removeAll()
    }
}
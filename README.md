# ios_base_project

# ios_base_project
📱 SwiftUI MVVM Base Project Documentation

  🏗️ Architecture Pattern: MVVM + Factory Pattern + Dependency Injection

  Primary Pattern: MVVM (Model-View-ViewModel)

  - Model: Data structures and business logic
  - View: SwiftUI views that display data
  - ViewModel: Manages UI state and business logic (similar to GetX Controllers)

  Supporting Patterns:

  1. Factory Pattern: For creating object instances
  2. Dependency Injection: For managing dependencies
  3. Repository Pattern: For data access abstraction
  4. Observer Pattern: Using Combine for reactive programming

  ---
  📁 Project Structure

  demo_project/
  ├── 📁 Core/
  │   ├── 📁 Network/               # Network layer
  │   │   ├── NetworkManager.swift   # HTTP client (like GetX HttpClient)
  │   │   ├── APIService.swift       # API endpoints wrapper
  │   │   └── NetworkError.swift     # Error handling
  │   ├── 📁 DI/                     # Dependency Injection
  │   │   └── DIContainer.swift      # Factory + DI container
  │   ├── 📁 Extensions/             # Swift extensions
  │   │   ├── String+Extensions.swift
  │   │   └── View+Extensions.swift
  │   └── 📁 Utils/                  # Utilities
  │       ├── BaseViewModel.swift    # Base class for ViewModels
  │       └── AppLogger.swift        # Logging utility
  ├── 📁 Features/                   # Feature-based modules
  │   ├── 📁 Home/
  │   │   ├── 📁 Model/
  │   │   │   ├── User.swift
  │   │   │   └── Post.swift
  │   │   ├── 📁 ViewModel/
  │   │   │   └── HomeViewModel.swift
  │   │   └── 📁 View/
  │   │       └── HomeView.swift
  │   └── 📁 Profile/
  │       ├── 📁 ViewModel/
  │       │   └── ProfileViewModel.swift
  │       └── 📁 View/
  │           └── ProfileView.swift
  ├── 📁 Common/
  │   ├── 📁 Components/             # Reusable UI components
  │   │   ├── LoadingView.swift
  │   │   └── ErrorView.swift
  │   └── 📁 Constants/              # App constants
  │       └── APIConstants.swift
  └── 📁 Resources/                  # Assets, colors, etc.

  ---

  1. Core Dependencies

  NetworkManager (HTTP Client)

  // Role: Handles all HTTP requests
  // Similar to: GetX HttpClient
  class NetworkManager: NetworkManagerProtocol {
      static let shared = NetworkManager()
      // Uses URLSession + Combine for reactive HTTP calls
  }

  APIService (API Wrapper)

  // Role: Wraps NetworkManager with specific API endpoints
  // Similar to: GetX ApiProvider
  class APIService: APIServiceProtocol {
      func getUsers() -> AnyPublisher<[User], NetworkError>
      func getUser(id: Int) -> AnyPublisher<User, NetworkError>
  }

  DIContainer (Factory + Dependency Injection)

  // Role: Creates and manages object instances
  // Similar to: GetX Get.put() + Get.find()
  class DIContainer: DIContainerProtocol {
      func register<T>(_ type: T.Type, factory: @escaping () -> T)
      func resolve<T>(_ type: T.Type) -> T
  }

  2. MVVM Dependencies

  BaseViewModel (Base Controller)

  // Role: Common functionality for all ViewModels
  // Similar to: GetX GetxController
  class BaseViewModel: ObservableObject {
      @Published var isLoading = false
      @Published var errorMessage: String?
      @Published var showError = false

      func handleError(_ error: Error)
      func startLoading()
      func stopLoading()
  }

  HomeViewModel (Feature Controller)

  // Role: Manages Home screen state and logic
  // Similar to: GetX Controller for specific feature
  class HomeViewModel: BaseViewModel, HomeViewModelProtocol {
      @Published var users: [User] = []
      @Published var posts: [Post] = []

      private let apiService: APIServiceProtocol

      func loadUsers()
      func loadPosts()
      func refresh()
  }

  3. UI Dependencies

  SwiftUI Views

  // Role: Display data from ViewModels
  // Similar to: GetX Obx() reactive widgets
  struct HomeView: View {
      @StateObject private var viewModel: HomeViewModel

      var body: some View {
          // Reactive UI that updates when viewModel changes
      }
  }

  Common Components

  // Role: Reusable UI components
  struct LoadingView: View        // Loading indicator
  struct ErrorView: View          // Error display with retry

  ---

  🔄 Data Flow & Dependency Chain

  1. App Startup

  demo_projectApp.swift
      ↓
  setupDependencies()
      ↓
  DIContainer.shared.setupDependencies()
      ↓
  Register all factories (APIService, ViewModels, etc.)

  2. View Creation

  HomeView init
      ↓
  DIContainer.shared.resolve(HomeViewModelProtocol.self)
      ↓
  Factory creates HomeViewModel with APIService dependency
      ↓
  HomeViewModel injected into HomeView

  3. Data Loading

  HomeView.onAppear()
      ↓
  viewModel.loadUsers()
      ↓
  apiService.getUsers()
      ↓
  networkManager.request()
      ↓
  URLSession + Combine
      ↓
  Data received → Update @Published properties
      ↓
  SwiftUI automatically updates UI

  ---

  🎯 Pattern Benefits

  MVVM Benefits:

  - ✅ Separation of Concerns: UI logic separated from business logic
  - ✅ Testability: ViewModels can be unit tested independently
  - ✅ Reactive UI: Automatic UI updates when data changes
  - ✅ Reusability: ViewModels can be reused across different views

  Factory Pattern Benefits:

  - ✅ Loose Coupling: Objects don't need to know about their dependencies
  - ✅ Easy Testing: Can inject mock dependencies for testing
  - ✅ Centralized Creation: All object creation logic in one place
  - ✅ Scalability: Easy to add new dependencies

  Dependency Injection Benefits:

  - ✅ Flexibility: Easy to swap implementations
  - ✅ Testability: Can inject mocks for unit testing
  - ✅ Maintainability: Changes to dependencies don't affect dependent classes
  - ✅ Single Responsibility: Each class has a single responsibility

  ---
  🚀 How to Use This Project

  1. Adding a New Feature

  // 1. Create Model
  struct MyModel: Codable { }

  // 2. Create ViewModel
  class MyViewModel: BaseViewModel {
      private let apiService = DIContainer.shared.resolve(APIServiceProtocol.self)
  }

  // 3. Create View
  struct MyView: View {
      @StateObject private var viewModel = DIContainer.shared.resolve(MyViewModelProtocol.self)
  }

  // 4. Register in DIContainer
  DIContainer.shared.register(MyViewModelProtocol.self) { MyViewModel() }

  2. Making API Calls

  // In your ViewModel
  func loadData() {
      startLoading()
      apiService.getData()
          .sink(
              receiveCompletion: { [weak self] completion in
                  self?.stopLoading()
                  if case .failure(let error) = completion {
                      self?.handleError(error)
                  }
              },
              receiveValue: { [weak self] data in
                  self?.data = data
              }
          )
          .store(in: &cancellables)
  }

  3. Error Handling

  // Automatic error handling in BaseViewModel
  // Just call handleError() and UI will show error alert
  handleError(NetworkError.noData)

  ---
  📦 Key Technologies

  - SwiftUI: Modern declarative UI framework
  - Combine: Reactive programming framework
  - URLSession: HTTP networking
  - Foundation: Core Swift framework
  - ObservableObject: State management
  - Protocol-Oriented Programming: For testability and flexibility

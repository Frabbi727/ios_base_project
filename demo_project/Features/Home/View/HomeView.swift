import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = DIContainer.shared.resolve(HomeViewModelProtocol.self) as! HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading && viewModel.users.isEmpty {
                    LoadingView()
                } else if viewModel.showError {
                    ErrorView(message: viewModel.errorMessage ?? "Unknown error") {
                        viewModel.refresh()
                    }
                } else {
                    List {
                        Section("Users") {
                            ForEach(viewModel.users) { user in
                                NavigationLink(destination: ProfileView(userId: user.id)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(user.name)
                                            .font(.headline)
                                        Text(user.email)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                        
                        Section("Recent Posts") {
                            ForEach(viewModel.posts.prefix(5)) { post in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(post.title)
                                        .font(.headline)
                                        .lineLimit(2)
                                    Text(post.body)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    .refreshable {
                        viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Home")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {
                    viewModel.showError = false
                }
                Button("Retry") {
                    viewModel.refresh()
                }
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
}

#Preview {
    HomeView()
}
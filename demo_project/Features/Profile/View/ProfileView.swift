import SwiftUI

struct ProfileView: View {
    let userId: Int
    @StateObject private var viewModel: ProfileViewModel
    
    init(userId: Int, viewModel: ProfileViewModel = DIContainer.shared.resolve(ProfileViewModelProtocol.self) as! ProfileViewModel) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                LoadingView()
            } else if viewModel.showError {
                ErrorView(message: viewModel.errorMessage ?? "Unknown error") {
                    viewModel.loadUser(id: userId)
                }
            } else if let user = viewModel.user {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // User Info Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Profile")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.headline)
                                Text("@\(user.username)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(user.email)
                                    .font(.body)
                                    .foregroundColor(.blue)
                                Text(user.phone)
                                    .font(.body)
                                Text(user.website)
                                    .font(.body)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Company Info Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Company")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.company.name)
                                    .font(.headline)
                                Text(user.company.catchPhrase)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                Text(user.company.bs)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        // Posts Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Posts (\(viewModel.userPosts.count))")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            ForEach(viewModel.userPosts) { post in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(post.title)
                                        .font(.headline)
                                    Text(post.body)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadUser(id: userId)
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {
                viewModel.showError = false
            }
            Button("Retry") {
                viewModel.loadUser(id: userId)
            }
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }
}

#Preview {
    NavigationView {
        ProfileView(userId: 1)
    }
}
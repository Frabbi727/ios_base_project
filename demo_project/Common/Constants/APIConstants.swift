import Foundation

struct APIConstants {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    static let timeout: TimeInterval = 30.0
    
    struct Endpoints {
        static let users = "/users"
        static let posts = "/posts"
        static let user = "/users/{id}"
        static let userPosts = "/users/{id}/posts"
    }
    
    struct HTTPMethods {
        static let get = "GET"
        static let post = "POST"
        static let put = "PUT"
        static let delete = "DELETE"
    }
}
//
//  demo_projectApp.swift
//  demo_project
//
//  Created by Md Fazle Rabbi on 16/7/25.
//

import SwiftUI

@main
struct demo_projectApp: App {
    
    init() {
        setupDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func setupDependencies() {
        DIContainer.shared.setupDependencies()
    }
}

//
//  Task_Flow_Versiyon_2App.swift
//  Task Flow Versiyon 2
//
//  Created by Doğa on 12.10.2025.
//

import SwiftUI

@main
struct Task_Flow_Versiyon_2App: App {
    init() {
        // Configure Firebase (currently mock)
        FirebaseManager.shared.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
        }
    }
}

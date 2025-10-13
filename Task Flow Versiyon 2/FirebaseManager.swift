//
//  FirebaseManager.swift
//  Task Flow Versiyon 2
//
//  Created on 13 Ekim 2025.
//

import Foundation

// MARK: - FirebaseManager (Temporary without Firebase)

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private init() {}
    
    func configure() {
        // Firebase configuration will be added here once Firebase is installed
        print("Firebase configuration placeholder - Install Firebase SDK first")
    }
}

// MARK: - Mock User for Testing
struct MockUser {
    let uid: String
    let email: String?
    let displayName: String?
    
    static let example = MockUser(
        uid: "mock-user-id",
        email: "test@example.com",
        displayName: "Test User"
    )
}
//
//  ProjectAnalytics.swift
//  Raptiye
//
//  Created on 16 Ekim 2025.
//

import Foundation

/// Proje Analitikleri Modeli - Android ProjectAnalytics.kt ile aynı
struct ProjectAnalytics: Identifiable {
    let id: String
    let projectId: String
    let totalTasks: Int
    let completedTasks: Int
    let inProgressTasks: Int
    let todoTasks: Int
    let completionRate: Double
    let averageTaskDuration: Double // Gün cinsinden
    let onTimeCompletionRate: Double
    let teamMembers: [User]
    
    /// Task tamamlanma oranı yüzde olarak
    var completionPercentage: Int {
        Int(completionRate * 100)
    }
    
    /// Zamanında tamamlanma oranı yüzde olarak
    var onTimePercentage: Int {
        Int(onTimeCompletionRate * 100)
    }
    
    init(
        id: String = UUID().uuidString,
        projectId: String,
        totalTasks: Int,
        completedTasks: Int,
        inProgressTasks: Int,
        todoTasks: Int,
        completionRate: Double,
        averageTaskDuration: Double,
        onTimeCompletionRate: Double,
        teamMembers: [User]
    ) {
        self.id = id
        self.projectId = projectId
        self.totalTasks = totalTasks
        self.completedTasks = completedTasks
        self.inProgressTasks = inProgressTasks
        self.todoTasks = todoTasks
        self.completionRate = completionRate
        self.averageTaskDuration = averageTaskDuration
        self.onTimeCompletionRate = onTimeCompletionRate
        self.teamMembers = teamMembers
    }
    
    /// Örnek analitik verisi
    static func sampleAnalytics(for projectId: String) -> ProjectAnalytics {
        ProjectAnalytics(
            projectId: projectId,
            totalTasks: 24,
            completedTasks: 16,
            inProgressTasks: 5,
            todoTasks: 3,
            completionRate: 0.67,
            averageTaskDuration: 5.2,
            onTimeCompletionRate: 0.85,
            teamMembers: User.sampleUsers
        )
    }
}

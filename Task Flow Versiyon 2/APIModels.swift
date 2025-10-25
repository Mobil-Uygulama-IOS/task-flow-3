//
//  APIModels.swift
//  Task Flow
//
//  Backend API için model tanımları
//

import Foundation

// MARK: - Request Models

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
    let displayName: String?
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct CreateProjectRequest: Codable {
    let name: String
    let description: String?
    let status: String
    let startDate: Date?
    let endDate: Date?
    let teamLeader: String
    let teamMembers: [String]
}

struct UpdateProjectRequest: Codable {
    let name: String?
    let description: String?
    let status: String?
    let startDate: Date?
    let endDate: Date?
    let teamMembers: [String]?
}

struct CreateTaskRequest: Codable {
    let projectId: String
    let title: String
    let description: String?
    let status: String
    let priority: String
    let assignedTo: String?
    let dueDate: Date?
}

struct UpdateTaskRequest: Codable {
    let title: String?
    let description: String?
    let status: String?
    let priority: String?
    let assignedTo: String?
    let dueDate: Date?
    let isCompleted: Bool?
}

// MARK: - Response Models

struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let data: UserData
    let token: String
}

struct UserData: Codable {
    let uid: String
    let username: String?
    let email: String
    let displayName: String?
    let photoUrl: String?
}

struct UserResponse: Codable {
    let success: Bool
    let data: UserData
}

struct ProjectsResponse: Codable {
    let success: Bool
    let count: Int
    let data: [ProjectData]
}

struct ProjectResponse: Codable {
    let success: Bool
    let message: String?
    let data: ProjectData
}

struct ProjectData: Codable {
    let _id: String
    let name: String
    let description: String?
    let status: String
    let startDate: Date?
    let endDate: Date?
    let teamLeader: UserData?
    let teamMembers: [UserData]?
    let tasks: [String]?
    let createdAt: Date
    let updatedAt: Date
}

struct TasksResponse: Codable {
    let success: Bool
    let count: Int
    let data: [TaskData]
}

struct TaskResponse: Codable {
    let success: Bool
    let message: String?
    let data: TaskData
}

struct TaskData: Codable {
    let _id: String
    let projectId: String
    let title: String
    let description: String?
    let status: String
    let priority: String
    let assignedTo: UserData?
    let dueDate: Date?
    let isCompleted: Bool
    let comments: [CommentData]?
    let createdAt: Date
    let updatedAt: Date
}

struct CommentData: Codable {
    let _id: String
    let author: UserData
    let content: String
    let createdAt: Date
}

struct MessageResponse: Codable {
    let success: Bool
    let message: String
}

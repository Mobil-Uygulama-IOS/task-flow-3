//
//  NetworkManager.swift
//  Task Flow
//
//  Network katmanı - Backend API ile iletişim
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    // Backend URL'i - gerçek IP adresinizi buraya yazın
    private let baseURL = "http://localhost:3000/api"
    
    private init() {}
    
    // MARK: - Generic Request Method
    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Token varsa Authorization header'ı ekle
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Body varsa encode et
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(httpResponse.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            print("❌ Decode error: \(error)")
            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            throw NetworkError.decodingError
        }
    }
    
    // MARK: - Authentication
    
    func register(username: String, email: String, password: String, displayName: String? = nil) async throws -> AuthResponse {
        let body = RegisterRequest(username: username, email: email, password: password, displayName: displayName)
        return try await request(endpoint: "/auth/register", method: "POST", body: body)
    }
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let body = LoginRequest(email: email, password: password)
        return try await request(endpoint: "/auth/login", method: "POST", body: body)
    }
    
    func getCurrentUser(token: String) async throws -> UserResponse {
        return try await request(endpoint: "/auth/me", method: "GET", token: token)
    }
    
    // MARK: - Projects
    
    func getProjects(token: String) async throws -> ProjectsResponse {
        return try await request(endpoint: "/projects", method: "GET", token: token)
    }
    
    func createProject(project: CreateProjectRequest, token: String) async throws -> ProjectResponse {
        return try await request(endpoint: "/projects", method: "POST", body: project, token: token)
    }
    
    func updateProject(id: String, project: UpdateProjectRequest, token: String) async throws -> ProjectResponse {
        return try await request(endpoint: "/projects/\(id)", method: "PUT", body: project, token: token)
    }
    
    func deleteProject(id: String, token: String) async throws -> MessageResponse {
        return try await request(endpoint: "/projects/\(id)", method: "DELETE", token: token)
    }
    
    // MARK: - Tasks
    
    func getTasks(projectId: String, token: String) async throws -> TasksResponse {
        return try await request(endpoint: "/tasks?projectId=\(projectId)", method: "GET", token: token)
    }
    
    func createTask(task: CreateTaskRequest, token: String) async throws -> TaskResponse {
        return try await request(endpoint: "/tasks", method: "POST", body: task, token: token)
    }
    
    func updateTask(id: String, task: UpdateTaskRequest, token: String) async throws -> TaskResponse {
        return try await request(endpoint: "/tasks/\(id)", method: "PUT", body: task, token: token)
    }
    
    func toggleTaskCompletion(id: String, token: String) async throws -> TaskResponse {
        return try await request(endpoint: "/tasks/\(id)/toggle", method: "PUT", token: token)
    }
    
    func deleteTask(id: String, token: String) async throws -> MessageResponse {
        return try await request(endpoint: "/tasks/\(id)", method: "DELETE", token: token)
    }
}

// MARK: - Network Error
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError
    case encodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz sunucu yanıtı"
        case .httpError(let code):
            return "HTTP Hatası: \(code)"
        case .decodingError:
            return "Veri çözümleme hatası"
        case .encodingError:
            return "Veri kodlama hatası"
        }
    }
}

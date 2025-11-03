//
//  ProjectManager.swift
//  Task Flow Versiyon 2
//
//  Created on 4 Kasım 2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class ProjectManager: ObservableObject {
    @Published var projects: [Project] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        print("📦 ProjectManager initialized")
        // Listener'ı init'te başlatma - kullanıcı giriş yaptıktan sonra başlatılacak
    }
    
    // MARK: - Real-time Listener
    
    func setupListener() {
        print("🔄 setupListener called")
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("⚠️ setupListener: No user logged in, skipping listener setup")
            return
        }
        
        print("👤 setupListener: User ID = \(userId)")
        
        // Eski listener varsa kaldır
        listener?.remove()
        
        listener = db.collection("users")
            .document(userId)
            .collection("projects")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                Task { @MainActor in
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        print("❌ Firestore listener hatası: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("⚠️ No documents in snapshot")
                        return
                    }
                    
                    self.projects = documents.compactMap { doc -> Project? in
                        try? doc.data(as: Project.self)
                    }
                    
                    print("✅ \(self.projects.count) proje yüklendi")
                }
            }
    }
    
    // MARK: - Fetch Projects
    
    func fetchProjects() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Kullanıcı oturum açmamış"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await db.collection("users")
                .document(userId)
                .collection("projects")
                .getDocuments()
            
            self.projects = snapshot.documents.compactMap { doc -> Project? in
                try? doc.data(as: Project.self)
            }
            
            print("✅ \(self.projects.count) proje yüklendi")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Proje yükleme hatası: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Create Project
    
    func createProject(_ project: Project) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış"])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let projectRef = db.collection("users")
                .document(userId)
                .collection("projects")
                .document(project.id.uuidString)
            
            try projectRef.setData(from: project)
            
            print("✅ Proje oluşturuldu: \(project.title)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Proje oluşturma hatası: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Update Project
    
    func updateProject(_ project: Project) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış"])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let projectRef = db.collection("users")
                .document(userId)
                .collection("projects")
                .document(project.id.uuidString)
            
            try projectRef.setData(from: project, merge: true)
            
            print("✅ Proje güncellendi: \(project.title)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Proje güncelleme hatası: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Delete Project
    
    func deleteProject(_ project: Project) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış"])
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await db.collection("users")
                .document(userId)
                .collection("projects")
                .document(project.id.uuidString)
                .delete()
            
            print("✅ Proje silindi: \(project.title)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Proje silme hatası: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Add Task to Project
    
    func addTask(_ task: ProjectTask, to projectId: UUID) async throws {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış"])
        }
        
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Proje bulunamadı"])
        }
        
        var project = projects[projectIndex]
        project.tasks.append(task)
        
        try await updateProject(project)
        
        print("✅ Görev eklendi: \(task.title)")
    }
    
    // MARK: - Update Task
    
    func updateTask(_ task: ProjectTask, in projectId: UUID) async throws {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Proje bulunamadı"])
        }
        
        var project = projects[projectIndex]
        
        if let taskIndex = project.tasks.firstIndex(where: { $0.id == task.id }) {
            project.tasks[taskIndex] = task
            try await updateProject(project)
            print("✅ Görev güncellendi: \(task.title)")
        }
    }
    
    // MARK: - Delete Task
    
    func deleteTask(_ taskId: UUID, from projectId: UUID) async throws {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Proje bulunamadı"])
        }
        
        var project = projects[projectIndex]
        project.tasks.removeAll { $0.id == taskId }
        
        try await updateProject(project)
        
        print("✅ Görev silindi")
    }
    
    // MARK: - Toggle Task Completion
    
    func toggleTaskCompletion(_ taskId: UUID, in projectId: UUID) async throws {
        guard let projectIndex = projects.firstIndex(where: { $0.id == projectId }) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Proje bulunamadı"])
        }
        
        var project = projects[projectIndex]
        
        if let taskIndex = project.tasks.firstIndex(where: { $0.id == taskId }) {
            project.tasks[taskIndex].isCompleted.toggle()
            try await updateProject(project)
            print("✅ Görev durumu değiştirildi")
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        listener?.remove()
    }
}

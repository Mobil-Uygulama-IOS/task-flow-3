//
//  TaskManager.swift
//  Task Flow Versiyon 2
//
//  Created on 4 Kasım 2025.
//

import Foundation
import FirebaseFirestore
import Combine

// MARK: - Task Manager (Firebase Firestore)

final class TaskManager: ObservableObject {
    @Published var tasks: [ProjectTask] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    // MARK: - Fetch Tasks
    func fetchTasks(for projectId: UUID) {
        isLoading = true
        
        // Real-time listener - görevler değiştiğinde otomatik güncellenir
        listener = db.collection("projects")
            .document(projectId.uuidString)
            .collection("tasks")
            .order(by: "createdDate", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("❌ Görev çekme hatası: \(error)")
                    self.isLoading = false
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.isLoading = false
                    return
                }
                
                self.tasks = documents.compactMap { doc -> ProjectTask? in
                    try? doc.data(as: ProjectTask.self)
                }
                
                self.isLoading = false
                print("✅ \(self.tasks.count) görev yüklendi")
            }
    }
    
    // MARK: - Add Task
    func addTask(_ task: ProjectTask, to projectId: UUID) async throws {
        do {
            try db.collection("projects")
                .document(projectId.uuidString)
                .collection("tasks")
                .document(task.id.uuidString)
                .setData(from: task)
            
            print("✅ Görev eklendi: \(task.title)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Görev ekleme hatası: \(error)")
            throw error
        }
    }
    
    // MARK: - Update Task
    func updateTask(_ task: ProjectTask, in projectId: UUID) async throws {
        do {
            try db.collection("projects")
                .document(projectId.uuidString)
                .collection("tasks")
                .document(task.id.uuidString)
                .setData(from: task, merge: true)
            
            print("✅ Görev güncellendi: \(task.title)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Görev güncelleme hatası: \(error)")
            throw error
        }
    }
    
    // MARK: - Delete Task
    func deleteTask(_ taskId: UUID, from projectId: UUID) async throws {
        do {
            try await db.collection("projects")
                .document(projectId.uuidString)
                .collection("tasks")
                .document(taskId.uuidString)
                .delete()
            
            print("✅ Görev silindi: \(taskId)")
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Görev silme hatası: \(error)")
            throw error
        }
    }
    
    // MARK: - Toggle Task Status
    func toggleTaskStatus(_ task: ProjectTask, in projectId: UUID) async throws {
        var updatedTask = task
        updatedTask.isCompleted.toggle()
        try await updateTask(updatedTask, in: projectId)
    }
    
    // MARK: - Cleanup
    func stopListening() {
        listener?.remove()
        listener = nil
    }
    
    deinit {
        stopListening()
    }
}

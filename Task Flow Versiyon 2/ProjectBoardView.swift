//
//  ProjectBoardView.swift
//  Raptiye
//
//  Created on 16 Ekim 2025.
//

import SwiftUI

/// Kanban Panosu Ekranı - Android ProjectBoardScreen ile birebir aynı
struct ProjectBoardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @State private var tasks: [ProjectTask] = []
    @State private var selectedTask: ProjectTask?
    @State private var showTaskDetail = false
    
    let tabs = ["Yapılacaklar", "Devam Ediyor", "Tamamlandı"]
    let selectedTabColor = Color.blue
    
    init() {
        // Örnek görevler yükle
        _tasks = State(initialValue: [
            ProjectTask.sampleTask,
            ProjectTask(
                title: "Backend API Development",
                description: "Develop RESTful API endpoints for project and task management.",
                assignee: ProjectTask.sampleAssignees[1],
                dueDate: Date().addingTimeInterval(20 * 24 * 60 * 60),
                isCompleted: false,
                priority: .high
            ),
            ProjectTask(
                title: "Database Schema Design",
                description: "Design and implement database schema for storing projects, tasks, and user data.",
                assignee: ProjectTask.sampleAssignees[0],
                dueDate: Date().addingTimeInterval(15 * 24 * 60 * 60),
                isCompleted: false,
                priority: .medium
            ),
            ProjectTask(
                title: "User Authentication",
                description: "Implement secure user authentication and authorization.",
                assignee: ProjectTask.sampleAssignees[2],
                dueDate: Date().addingTimeInterval(-5 * 24 * 60 * 60),
                isCompleted: true,
                priority: .high
            )
        ])
    }
    
    var filteredTasks: [ProjectTask] {
        switch selectedTab {
        case 0: // Yapılacaklar
            return tasks.filter { !$0.isCompleted }
        case 1: // Devam Ediyor
            return tasks.filter { !$0.isCompleted }
        case 2: // Tamamlandı
            return tasks.filter { $0.isCompleted }
        default:
            return tasks
        }
    }
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(themeManager.textColor)
                    }
                    
                    Spacer()
                    
                    Text("Proje Panosu")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Custom Tab Bar
                HStack(spacing: 0) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = index
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(tabs[index])
                                    .font(.system(size: 15, weight: selectedTab == index ? .semibold : .regular))
                                    .foregroundColor(selectedTab == index ? selectedTabColor : themeManager.secondaryTextColor)
                                
                                // Bottom indicator
                                Rectangle()
                                    .fill(selectedTab == index ? selectedTabColor : Color.clear)
                                    .frame(height: 2)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Tasks List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTasks) { task in
                            TaskBoardCard(task: task)
                                .environmentObject(themeManager)
                                .onTapGesture {
                                    selectedTask = task
                                    showTaskDetail = true
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showTaskDetail) {
            if let task = selectedTask {
                TaskDetailView(task: task)
                    .environmentObject(themeManager)
            }
        }
    }
}

// MARK: - Task Board Card
struct TaskBoardCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let task: ProjectTask
    
    var body: some View {
        HStack(spacing: 16) {
            // Sol taraf - Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: "list.bullet")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            
            // Orta - Başlık ve tarih
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                
                if task.dueDate != nil {
                    Text(task.formattedDueDate)
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.cardBackground)
        )
    }
}

// MARK: - Preview
struct ProjectBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectBoardView()
            .environmentObject(ThemeManager.shared)
            .preferredColorScheme(.dark)
        
        ProjectBoardView()
            .environmentObject(ThemeManager.shared)
            .preferredColorScheme(.light)
    }
}

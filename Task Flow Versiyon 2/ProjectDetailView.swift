import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var localization = LocalizationManager.shared
    let project: Project
    @State private var selectedTask: ProjectTask?
    @State private var showTaskDetail = false
    @State private var showAnalytics = false
    
    var body: some View {
        ZStack {
            // Background
            themeManager.backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(themeManager.textColor)
                    }
                    
                    Spacer()
                    
                    Text(localization.localizedString("ProjectDetails"))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textColor)
                    
                    Spacer()
                    
                    // Analytics button
                    Button(action: {
                        showAnalytics = true
                    }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title3)
                            .foregroundColor(themeManager.textColor)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Project Info
                        VStack(alignment: .leading, spacing: 12) {
                            Text(project.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(themeManager.textColor)
                            
                            Text(project.description)
                                .font(.system(size: 15))
                                .foregroundColor(themeManager.secondaryTextColor)
                                .lineSpacing(4)
                            
                            if !project.dueDateString.isEmpty {
                                Text(project.dueDateString)
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                            }
                            
                            // Progress
                            if project.tasksCount > 0 {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(localization.localizedString("Progress"))
                                            .font(.system(size: 14))
                                            .foregroundColor(themeManager.secondaryTextColor)
                                        
                                        Spacer()
                                        
                                        Text("\(project.completedTasksCount)/\(project.tasksCount)")
                                            .font(.system(size: 14))
                                            .foregroundColor(themeManager.textColor)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(themeManager.secondaryTextColor.opacity(0.3))
                                                .frame(height: 8)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.blue)
                                                .frame(width: geometry.size.width * project.progressPercentage, height: 8)
                                        }
                                    }
                                    .frame(height: 8)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.cardBackground)
                        )
                        
                        // Team Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text(localization.localizedString("Team"))
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(themeManager.textColor)
                            
                            // Team Leader
                            if let leader = project.teamLeader {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(localization.localizedString("TeamLeader"))
                                        .font(.system(size: 14))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    ProjectTeamMemberCard(user: leader, taskCount: countTasksForUser(leader), isLeader: true)
                                }
                            }
                            
                            // Team Members
                            if !project.teamMembers.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(localization.localizedString("TeamMembers"))
                                        .font(.system(size: 14))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    ForEach(project.teamMembers, id: \.uid) { member in
                                        ProjectTeamMemberCard(user: member, taskCount: countTasksForUser(member), isLeader: false)
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(themeManager.cardBackground)
                        )
                        
                        // Tasks Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(localization.localizedString("Tasks"))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(themeManager.textColor)
                                
                                Spacer()
                                
                                Button(action: {
                                    // Add new task
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            if project.tasks.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "tray")
                                        .font(.system(size: 40))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                    
                                    Text("Henüz görev eklenmemiş")
                                        .font(.system(size: 15))
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                ForEach(project.tasks) { task in
                                    TaskRowCard(task: task)
                                        .environmentObject(themeManager)
                                        .onTapGesture {
                                            selectedTask = task
                                            showTaskDetail = true
                                        }
                                }
                            }
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showTaskDetail) {
            if let task = selectedTask {
                TaskDetailView(task: task)
            }
        }
        .sheet(isPresented: $showAnalytics) {
            ProjectAnalyticsView(project: project)
        }
    }
    
    // MARK: - Helper Methods
    private func countTasksForUser(_ user: User) -> Int {
        project.tasks.filter { task in
            guard let assignee = task.assignee, let userEmail = user.email else { return false }
            return assignee.email == userEmail
        }.count
    }
}

// MARK: - Team Member Card
struct ProjectTeamMemberCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let user: User
    let taskCount: Int
    let isLeader: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack {
                Circle()
                    .fill(isLeader ? Color.orange.opacity(0.2) : Color.blue.opacity(0.2))
                    .frame(width: 45, height: 45)
                
                Text(user.initials)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isLeader ? .orange : .blue)
            }
            
            // User Info
            VStack(alignment: .leading, spacing: 3) {
                Text(user.displayName ?? "User")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.textColor)
                
                if let email = user.email {
                    Text(email)
                        .font(.caption)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            
            Spacer()
            
            // Task Count Badge
            if taskCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("\(taskCount)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(themeManager.textColor)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(themeManager.searchBackground)
                .cornerRadius(12)
            }
        }
        .padding(12)
        .background(themeManager.searchBackground)
        .cornerRadius(12)
    }
}

// MARK: - Task Row Card
struct TaskRowCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let task: ProjectTask
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkbox
            Button(action: {
                // Toggle task completion
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : themeManager.secondaryTextColor)
            }
            
            // Task info
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(themeManager.textColor)
                    .strikethrough(task.isCompleted)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    if let assignee = task.assignee {
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 10))
                            Text(assignee.name)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(themeManager.secondaryTextColor)
                    }
                    
                    if !task.dueDateString.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10))
                            Text(task.dueDateString)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(themeManager.cardBackground)
        )
    }
}

// MARK: - Preview
struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: Project.sampleProjects[1])
            .environmentObject(ThemeManager.shared)
    }
}

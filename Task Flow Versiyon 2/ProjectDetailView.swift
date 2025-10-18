import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let project: Project
    @State private var selectedTask: ProjectTask?
    @State private var showTaskDetail = false
    @State private var showAnalytics = false
    
    var teamMembers: [TaskAssignee] {
        var members: [TaskAssignee] = []
        var seenIds = Set<UUID>()
        
        for task in project.tasks {
            if let assignee = task.assignee, !seenIds.contains(assignee.id) {
                members.append(assignee)
                seenIds.insert(assignee.id)
            }
        }
        return members
    }
    
    var projectLeader: TaskAssignee? {
        teamMembers.first
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.11, green: 0.13, blue: 0.16)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Proje Detayları")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Analytics button
                    Button(action: {
                        showAnalytics = true
                    }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.title3)
                            .foregroundColor(.white)
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
                                .foregroundColor(.white)
                            
                            Text(project.description)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
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
                                        Text("İlerleme")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        Text("\(project.completedTasksCount)/\(project.tasksCount)")
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                    }
                                    
                                    GeometryReader { geometry in
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 4)
                                                .fill(Color.gray.opacity(0.3))
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
                                .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                        )
                        
                        // Ekip Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Ekip")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Ekip Lideri
                            if let leader = projectLeader {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Ekip Lideri")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    TeamMemberRow(member: leader, isLeader: true)
                                }
                            }
                            
                            // Ekip Üyeleri
                            if teamMembers.count > 1 {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Ekip Üyeleri")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    ForEach(teamMembers.dropFirst()) { member in
                                        TeamMemberRow(member: member, isLeader: false)
                                    }
                                }
                            }
                        }
                        
                        // Görevler Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Görevler")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
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
                                        .foregroundColor(.gray)
                                    
                                    Text("Henüz görev eklenmemiş")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                            } else {
                                ForEach(project.tasks) { task in
                                    TaskRowCard(task: task)
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
}

// MARK: - Team Member Row
struct TeamMemberRow: View {
    let member: TaskAssignee
    let isLeader: Bool
    
    var avatarColor: Color {
        isLeader ? .orange : .blue
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(avatarColor.opacity(0.3))
                .frame(width: 45, height: 45)
                .overlay(
                    Text(String(member.name.prefix(1)).uppercased())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(avatarColor)
                )
            
            // Member info
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(member.email)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.2, green: 0.22, blue: 0.26))
        )
    }
}

// MARK: - Task Row Card
struct TaskRowCard: View {
    let task: ProjectTask
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkbox
            Button(action: {
                // Toggle task completion
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            
            // Task info
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
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
                        .foregroundColor(.gray)
                    }
                    
                    if !task.dueDateString.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10))
                            Text(task.dueDateString)
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
        )
    }
}

// MARK: - Preview
struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView(project: Project.sampleProjects[0])
            .preferredColorScheme(.dark)
    }
}

import SwiftUI

struct ProjectDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var project: Project
    @State private var selectedTask: ProjectTask?
    @State private var showAnalytics = false
    @State private var showAddTask = false
    
    var teamMembers: [User] {
        var members: [User] = []
        if let leader = project.teamLeader {
            members.append(leader)
        }
        members.append(contentsOf: project.teamMembers)
        return members
    }
    
    var projectLeader: User? {
        project.teamLeader ?? project.teamMembers.first
    }
    
    var priorityColor: Color {
        guard let task = selectedTask else { return .blue }
        switch task.priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
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
                            if project.tasks.count > 0 {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("İlerleme")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                        
                                        Text("\(project.tasks.filter { $0.isCompleted }.count)/\(project.tasks.count)")
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
                                                .frame(width: geometry.size.width * (project.tasks.count > 0 ? Double(project.tasks.filter { $0.isCompleted }.count) / Double(project.tasks.count) : 0), height: 8)
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
                                    showAddTask = true
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
                                ForEach(Array(project.tasks.enumerated()), id: \.element.id) { index, task in
                                    TaskRowCard(task: task) {
                                        // Toggle completion
                                        project.tasks[index].isCompleted.toggle()
                                    }
                                    .onTapGesture {
                                        selectedTask = task
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
        .sheet(item: $selectedTask) { task in
            TaskDetailView(task: task)
        }
        .sheet(isPresented: $showAnalytics) {
            ProjectAnalyticsView(project: project)
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskView(
                tasks: $project.tasks,
                projectId: project.id,
                availableAssignees: teamMembers
            )
        }
    }
}

// MARK: - Team Member Row
struct TeamMemberRow: View {
    let member: User
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
                    Text(member.initials)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(avatarColor)
                )
            
            // Member info
            VStack(alignment: .leading, spacing: 4) {
                Text(member.displayName ?? "Unknown")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(member.email ?? "")
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
    var onToggleComplete: (() -> Void)?
    
    var priorityColor: Color {
        switch task.priority {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Checkbox
            Button(action: {
                onToggleComplete?()
            }) {
                ZStack {
                    if task.isCompleted {
                        // Tamamlanmış - yeşil dolu daire
                        Circle()
                            .fill(Color.green)
                            .frame(width: 24, height: 24)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        // Tamamlanmamış - gri çember
                        Circle()
                            .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            // Task info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(task.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .strikethrough(task.isCompleted)
                        .lineLimit(1)
                    
                    // Priority Badge
                    HStack(spacing: 3) {
                        Circle()
                            .fill(priorityColor)
                            .frame(width: 6, height: 6)
                        
                        Text(task.priority.rawValue)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(priorityColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(priorityColor.opacity(0.2))
                    )
                }
                
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
        ProjectDetailView(project: .constant(Project.sampleProjects[0]))
            .preferredColorScheme(.dark)
    }
}

import SwiftUI
import Charts

struct ProjectAnalyticsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab: AnalyticsTab = .overview
    let project: Project
    
    var body: some View {
        ZStack {
            // Dark background
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
                    
                    Text("Project Analytics")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Image(systemName: "arrow.left")
                        .font(.title3)
                        .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Tab Bar
                HStack(spacing: 0) {
                    ForEach(AnalyticsTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = tab
                            }
                        }) {
                            Text(tab.rawValue)
                                .font(.system(size: 15, weight: selectedTab == tab ? .semibold : .regular))
                                .foregroundColor(selectedTab == tab ? .white : .gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedTab == tab ? Color.blue : Color.clear
                                )
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Content
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case .overview:
                            OverviewTabContent(project: project)
                        case .progress:
                            ProgressTabContent(project: project)
                        case .team:
                            TeamTabContent(project: project)
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Analytics Tab Enum
enum AnalyticsTab: String, CaseIterable {
    case overview = "Overview"
    case progress = "Progress"
    case team = "Team"
}

// MARK: - Overview Tab Content
struct OverviewTabContent: View {
    let project: Project
    
    var completionRate: Double {
        guard project.tasksCount > 0 else { return 0 }
        return Double(project.completedTasksCount) / Double(project.tasksCount) * 100
    }
    
    var completedCount: Int {
        project.completedTasksCount
    }
    
    var inProgressCount: Int {
        project.tasks.filter { !$0.isCompleted }.count
    }
    
    var pendingCount: Int {
        project.tasks.filter { !$0.isCompleted }.count
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Task Completion Rate Card
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Completion Rate")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(Int(completionRate))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 6) {
                        Text("Last 30 Days")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("+10%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.green)
                    }
                }
                
                // Bar Chart
                HStack(alignment: .bottom, spacing: 20) {
                    // Completed
                    VStack(spacing: 8) {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color(red: 0.2, green: 0.25, blue: 0.35))
                                .frame(height: 60)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 80)
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        
                        Text("Completed")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    // In Progress
                    VStack(spacing: 8) {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color(red: 0.2, green: 0.25, blue: 0.35))
                                .frame(height: 20)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 120)
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        
                        Text("In Progress")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    // Pending
                    VStack(spacing: 8) {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color(red: 0.2, green: 0.25, blue: 0.35))
                                .frame(height: 80)
                            
                            Rectangle()
                                .fill(Color.blue)
                                .frame(height: 60)
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                        
                        Text("Pending")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: 180)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
            )
            
            // Project Timeline Card
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Project Timeline")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("120 days")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 6) {
                        Text("Current Project")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("-15%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.red)
                    }
                }
                
                // Line Chart
                TimelineChartView()
                    .frame(height: 150)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
            )
        }
    }
}

// MARK: - Timeline Chart View
struct TimelineChartView: View {
    let dataPoints: [ChartDataPoint] = [
        ChartDataPoint(week: "Week 1", value: 75),
        ChartDataPoint(week: "Week 2", value: 45),
        ChartDataPoint(week: "Week 3", value: 60),
        ChartDataPoint(week: "Week 4", value: 30),
        ChartDataPoint(week: "Week 5", value: 50),
        ChartDataPoint(week: "Week 6", value: 85),
        ChartDataPoint(week: "Week 7", value: 65)
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            // Chart area
            GeometryReader { geometry in
                ZStack {
                    // Line path
                    Path { path in
                        let width = geometry.size.width
                        let height = geometry.size.height
                        let stepX = width / CGFloat(dataPoints.count - 1)
                        
                        for (index, point) in dataPoints.enumerated() {
                            let x = CGFloat(index) * stepX
                            let y = height - (CGFloat(point.value) / 100.0 * height)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                }
            }
            
            // Week labels
            HStack {
                ForEach(["Week 1", "Week 2", "Week 3", "Week 4"], id: \.self) { week in
                    Text(week)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

struct ChartDataPoint {
    let week: String
    let value: Double
}

// MARK: - Progress Tab Content
struct ProgressTabContent: View {
    let project: Project
    
    var body: some View {
        VStack(spacing: 20) {
            // Progress overview
            VStack(alignment: .leading, spacing: 16) {
                Text("Overall Progress")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Tasks")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("\(project.tasksCount)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Completed")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("\(project.completedTasksCount)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                    )
                }
                
                // Progress bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Completion Rate")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("\(Int(project.progressPercentage * 100))%")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(red: 0.2, green: 0.25, blue: 0.35))
                                .frame(height: 16)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .frame(width: geometry.size.width * project.progressPercentage, height: 16)
                        }
                    }
                    .frame(height: 16)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                )
            }
            
            // Task breakdown
            VStack(alignment: .leading, spacing: 16) {
                Text("Task Breakdown")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                ForEach(project.tasks) { task in
                    HStack(spacing: 12) {
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(task.isCompleted ? .green : .gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            
                            if let assignee = task.assignee {
                                Text(assignee.name)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                    )
                }
            }
        }
    }
}

// MARK: - Team Tab Content
struct TeamTabContent: View {
    let project: Project
    
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
    
    func tasksForMember(_ member: TaskAssignee) -> [ProjectTask] {
        project.tasks.filter { $0.assignee?.id == member.id }
    }
    
    func completedTasksForMember(_ member: TaskAssignee) -> Int {
        project.tasks.filter { $0.assignee?.id == member.id && $0.isCompleted }.count
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Team Members")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                if teamMembers.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        
                        Text("No team members assigned")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    ForEach(teamMembers) { member in
                        TeamMemberCard(
                            member: member,
                            totalTasks: tasksForMember(member).count,
                            completedTasks: completedTasksForMember(member)
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Team Member Card
struct TeamMemberCard: View {
    let member: TaskAssignee
    let totalTasks: Int
    let completedTasks: Int
    
    var completionRate: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                )
            
            // Member info
            VStack(alignment: .leading, spacing: 6) {
                Text(member.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(member.email)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                HStack(spacing: 8) {
                    Text("\(completedTasks)/\(totalTasks) tasks")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text("\(Int(completionRate * 100))%")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
        )
    }
}

// MARK: - Preview
struct ProjectAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectAnalyticsView(project: Project.sampleProjects[2])
            .preferredColorScheme(.dark)
    }
}

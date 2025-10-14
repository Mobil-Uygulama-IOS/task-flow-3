import Foundation

// MARK: - Project Status Enum
enum ProjectStatus: String, Codable {
    case todo = "Yapılacaklar"
    case inProgress = "Devam Ediyor"
    case completed = "Tamamlandı"
}

// MARK: - Proje Data Modeli
struct Project: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let iconName: String
    let iconColor: String
    let createdDate: Date
    var status: ProjectStatus
    let dueDate: Date?
    var tasks: [Task]
    
    init(title: String, description: String, iconName: String = "folder.fill", iconColor: String = "blue", status: ProjectStatus = .todo, dueDate: Date? = nil, tasks: [Task] = []) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.iconColor = iconColor
        self.createdDate = Date()
        self.status = status
        self.dueDate = dueDate
        self.tasks = tasks
    }
    
    var tasksCount: Int {
        tasks.count
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var progressPercentage: Double {
        guard tasksCount > 0 else { return 0.0 }
        return Double(completedTasksCount) / Double(tasksCount)
    }
    
    var isCompleted: Bool {
        status == .completed
    }
    
    var dueDateString: String {
        guard let dueDate = dueDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "tr_TR")
        return "Son teslim: \(formatter.string(from: dueDate))"
    }
}

// MARK: - Sample Data
extension Project {
    static let sampleProjects = [
        // Yapılacaklar
        Project(
            title: "Proje 1: Web Sitesi Tasarımı",
            description: "Web sitesi tasarımının tamamlanması",
            iconName: "list.bullet",
            iconColor: "blue",
            status: .todo,
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 20)),
            tasks: [
                Task(
                    title: "UI/UX Design for Mobile App",
                    description: "Create a modern and user-friendly interface for the new student project tracking application.",
                    assignee: Task.sampleAssignees[0],
                    dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 20)),
                    comments: [
                        TaskComment(
                            author: Task.sampleAssignees[0],
                            content: "Initial project scope and objectives defined.",
                            createdDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 10)) ?? Date()
                        )
                    ]
                )
            ]
        ),
        Project(
            title: "Proje 4: Blog Platformu",
            description: "Blog platformu geliştirmesi",
            iconName: "list.bullet",
            iconColor: "blue",
            status: .todo,
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5)),
            tasks: []
        ),
        
        // Devam Ediyor
        Project(
            title: "Proje 2: Mobil Uygulama Geliştirme",
            description: "Mobil uygulama geliştirme projesi",
            iconName: "list.bullet",
            iconColor: "blue",
            status: .inProgress,
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 25)),
            tasks: [
                Task(
                    title: "Backend API Development",
                    description: "Develop REST API for mobile application",
                    assignee: Task.sampleAssignees[1],
                    dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 15)),
                    isCompleted: true
                ),
                Task(
                    title: "Database Design",
                    description: "Design and implement database schema",
                    assignee: Task.sampleAssignees[1],
                    dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 20))
                )
            ]
        ),
        
        // Tamamlandı
        Project(
            title: "Proje 3: Pazarlama Kampanyası",
            description: "Pazarlama kampanyası planlaması",
            iconName: "list.bullet",
            iconColor: "blue",
            status: .completed,
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 30)),
            tasks: [
                Task(
                    title: "Market Research",
                    description: "Complete market research analysis",
                    assignee: Task.sampleAssignees[2],
                    dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 10)),
                    isCompleted: true
                )
            ]
        )
    ]
}
import Foundation

// MARK: - Task Assignee
struct TaskAssignee: Identifiable, Codable {
    var id = UUID()
    var name: String
    var avatarName: String
    var email: String
    
    init(id: UUID = UUID(), name: String, avatarName: String, email: String) {
        self.id = id
        self.name = name
        self.avatarName = avatarName
        self.email = email
    }
}

// MARK: - Task Comment
struct TaskComment: Identifiable, Codable {
    var id = UUID()
    var author: TaskAssignee
    var content: String
    var createdDate: Date
    
    init(id: UUID = UUID(), author: TaskAssignee, content: String, createdDate: Date) {
        self.id = id
        self.author = author
        self.content = content
        self.createdDate = createdDate
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: createdDate)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: createdDate)
    }
}

// MARK: - Task Priority
enum TaskPriority: String, Codable {
    case low = "Düşük"
    case medium = "Orta"
    case high = "Yüksek"
}

// MARK: - ProjectTask Model
struct ProjectTask: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var assignee: TaskAssignee?
    var dueDate: Date?
    var comments: [TaskComment]
    var projectId: UUID?
    var isCompleted: Bool
    var priority: TaskPriority
    var createdDate: Date
    
    init(id: UUID = UUID(), title: String, description: String, assignee: TaskAssignee? = nil, dueDate: Date? = nil, comments: [TaskComment] = [], projectId: UUID? = nil, isCompleted: Bool = false, priority: TaskPriority = .medium, createdDate: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.assignee = assignee
        self.dueDate = dueDate
        self.comments = comments
        self.projectId = projectId
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdDate = createdDate
    }
    
    var dueDateString: String {
        guard let dueDate = dueDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dueDate)
    }
    
    /// Formatlanmış son teslim tarihi - Android ile aynı
    var formattedDueDate: String {
        guard let dueDate = dueDate else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: dueDate)
    }
    
    /// Formatlanmış oluşturulma tarihi
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: createdDate)
    }
}

// MARK: - Sample Data
extension ProjectTask {
    static let sampleAssignees: [TaskAssignee] = [
        TaskAssignee(name: "Emily Carter", avatarName: "person.circle.fill", email: "emily@example.com"),
        TaskAssignee(name: "David Lee", avatarName: "person.circle.fill", email: "david@example.com"),
        TaskAssignee(name: "Sarah Johnson", avatarName: "person.circle.fill", email: "sarah@example.com")
    ]
    
    static var sampleTask: ProjectTask {
        ProjectTask(
            title: "UI/UX Design for Mobile App",
            description: "Create a modern and user-friendly interface for the new student project tracking application.",
            assignee: sampleAssignees[0],
            dueDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 20)),
            comments: [
                TaskComment(
                    author: sampleAssignees[0],
                    content: "Initial project scope and objectives defined.",
                    createdDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 10)) ?? Date()
                ),
                TaskComment(
                    author: sampleAssignees[1],
                    content: "Resources and tools required for the project identified.",
                    createdDate: Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 12)) ?? Date()
                )
            ],
            isCompleted: false,
            priority: .high
        )
    }
}

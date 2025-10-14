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
    let tasksCount: Int
    let completedTasksCount: Int
    
    init(title: String, description: String, iconName: String = "folder.fill", iconColor: String = "blue", status: ProjectStatus = .todo, dueDate: Date? = nil, tasksCount: Int = 0, completedTasksCount: Int = 0) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.iconColor = iconColor
        self.createdDate = Date()
        self.status = status
        self.dueDate = dueDate
        self.tasksCount = tasksCount
        self.completedTasksCount = completedTasksCount
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
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 20))
        ),
        Project(
            title: "Proje 4: Blog Platformu",
            description: "Blog platformu geliştirmesi",
            iconName: "list.bullet",
            iconColor: "blue",
            status: .todo,
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 5))
        ),
        
        // Devam Ediyor
        Project(
            title: "Proje 2: Mobil Uygulama Geliştirme",
            description: "Mobil uygulama geliştirme projesi",
            iconName: "list.bullet",
            iconColor: "blue",
            status: .inProgress,
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 25)),
            tasksCount: 12,
            completedTasksCount: 7
        ),
        
        // Tamamlandı
        Project(
            title: "Proje 3: Pazarlama Kampanyası",
            description: "Pazarlama kampanyası planlaması",
            iconName: "list.bullet",
            iconColor: "blue",
            status: .completed,
            dueDate: Calendar.current.date(from: DateComponents(year: 2025, month: 5, day: 30)),
            tasksCount: 8,
            completedTasksCount: 8
        )
    ]
}
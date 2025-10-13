import Foundation

// MARK: - Proje Data Modeli
struct Project: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let iconName: String
    let iconColor: String
    let createdDate: Date
    let isCompleted: Bool
    let tasksCount: Int
    let completedTasksCount: Int
    
    init(title: String, description: String, iconName: String = "folder.fill", iconColor: String = "blue", isCompleted: Bool = false, tasksCount: Int = 0, completedTasksCount: Int = 0) {
        self.title = title
        self.description = description
        self.iconName = iconName
        self.iconColor = iconColor
        self.createdDate = Date()
        self.isCompleted = isCompleted
        self.tasksCount = tasksCount
        self.completedTasksCount = completedTasksCount
    }
    
    var progressPercentage: Double {
        guard tasksCount > 0 else { return 0.0 }
        return Double(completedTasksCount) / Double(tasksCount)
    }
}

// MARK: - Sample Data
extension Project {
    static let sampleProjects = [
        Project(
            title: "Proje Yönetimi Uygulaması",
            description: "Proje yönetimi uygulamasının tasarımı ve geliştirme süreci",
            iconName: "iphone",
            iconColor: "mint",
            tasksCount: 15,
            completedTasksCount: 8
        ),
        Project(
            title: "E-ticaret Uygulaması",
            description: "E-ticaret uygulamasının tasarımı",
            iconName: "cart.fill", 
            iconColor: "orange",
            tasksCount: 12,
            completedTasksCount: 5
        ),
        Project(
            title: "Sosyal Medya Uygulaması",
            description: "Sosyal medya uygulamasının tasarımı",
            iconName: "bubble.left.and.bubble.right.fill",
            iconColor: "blue",
            tasksCount: 8,
            completedTasksCount: 3
        )
    ]
}
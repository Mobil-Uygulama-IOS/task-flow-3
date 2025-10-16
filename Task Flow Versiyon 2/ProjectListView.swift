import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var searchText = ""
    @State private var selectedSortOption = "Tarih"
    @State private var selectedFilterOption = "Tümü"
    @State private var projects = Project.sampleProjects
    @State private var showAnalytics = false
    @State private var showProjectBoard = false
    @State private var selectedProject: Project?
    
    let sortOptions = ["Tarih", "İsim", "İlerleme"]
    let filterOptions = ["Tümü", "Aktif", "Tamamlanan"]
    
    var filteredProjects: [Project] {
        var filtered = projects
        
        // Arama filtresi
        if !searchText.isEmpty {
            filtered = filtered.filter { project in
                project.title.localizedCaseInsensitiveContains(searchText) ||
                project.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Durum filtresi
        switch selectedFilterOption {
        case "Aktif":
            filtered = filtered.filter { !$0.isCompleted }
        case "Tamamlanan":
            filtered = filtered.filter { $0.isCompleted }
        default:
            break
        }
        
        // Sıralama
        switch selectedSortOption {
        case "İsim":
            filtered = filtered.sorted { $0.title < $1.title }
        case "İlerleme":
            filtered = filtered.sorted { $0.progressPercentage > $1.progressPercentage }
        default: // Tarih
            filtered = filtered.sorted { $0.createdDate > $1.createdDate }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic background based on theme
                themeManager.backgroundColor
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with title and buttons (Android style)
                    HStack {
                        Text("Projeler")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.textColor)
                        
                        Spacer()
                        
                        HStack(spacing: 12) {
                            // Analytics button
                            Button(action: {
                                selectedProject = projects.first
                                showAnalytics = true
                            }) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.orange)
                                    .clipShape(Circle())
                            }
                            
                            // Kanban Board button
                            Button(action: {
                                showProjectBoard = true
                            }) {
                                Image(systemName: "square.grid.2x2.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.green)
                                    .clipShape(Circle())
                            }
                            
                            // Add new project button
                            Button(action: {
                                addNewProject()
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        TextField("Projelerde ara", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(themeManager.textColor)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(themeManager.searchBackground)
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Sort and Filter buttons
                    HStack(spacing: 12) {
                        // Sort dropdown
                        Menu {
                            ForEach(sortOptions, id: \.self) { option in
                                Button(action: {
                                    selectedSortOption = option
                                }) {
                                    HStack {
                                        Text(option)
                                        if selectedSortOption == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("Sırala")
                                Image(systemName: "chevron.down")
                            }
                            .font(.subheadline)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(themeManager.cardBackground)
                            .cornerRadius(8)
                        }
                        
                        // Filter dropdown
                        Menu {
                            ForEach(filterOptions, id: \.self) { option in
                                Button(action: {
                                    selectedFilterOption = option
                                }) {
                                    HStack {
                                        Text(option)
                                        if selectedFilterOption == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text("Filtrele")
                                Image(systemName: "chevron.down")
                            }
                            .font(.subheadline)
                            .foregroundColor(themeManager.textColor)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(themeManager.cardBackground)
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Projects section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Projelerim")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(themeManager.textColor)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        
                        // Projects list
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredProjects) { project in
                                    ProjectCardView(project: project)
                                        .environmentObject(themeManager)
                                        .onTapGesture {
                                            // Navigate to project detail
                                        }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAnalytics) {
            if let project = selectedProject {
                ProjectAnalyticsView(project: project)
                    .environmentObject(themeManager)
            }
        }
        .sheet(isPresented: $showProjectBoard) {
            ProjectBoardView()
                .environmentObject(themeManager)
        }
    }
    
    private func addNewProject() {
        let newProject = Project(
            title: "Yeni Proje \(projects.count + 1)",
            description: "Yeni proje açıklaması",
            iconName: "folder.fill",
            iconColor: "green"
        )
        projects.append(newProject)
    }
}

// MARK: - Project Card View
struct ProjectCardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let project: Project
    
    var body: some View {
        HStack(spacing: 16) {
            // Project icon
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(project.iconColor).opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: project.iconName)
                    .font(.title2)
                    .foregroundColor(Color(project.iconColor))
            }
            
            // Project info
            VStack(alignment: .leading, spacing: 4) {
                Text(project.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.textColor)
                    .lineLimit(1)
                
                Text(project.description)
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Progress bar (if has tasks)
                if project.tasksCount > 0 {
                    HStack(spacing: 8) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(.systemGray4))
                                    .frame(height: 4)
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.blue)
                                    .frame(width: geometry.size.width * project.progressPercentage, height: 4)
                            }
                        }
                        .frame(height: 4)
                        
                        Text("\(project.completedTasksCount)/\(project.tasksCount)")
                            .font(.caption)
                            .foregroundColor(themeManager.secondaryTextColor)
                            .frame(minWidth: 30)
                    }
                }
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .padding(16)
        .background(themeManager.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Preview
struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
            .environmentObject(ThemeManager.shared)
            .preferredColorScheme(.light)
        
        ProjectListView()
            .environmentObject(ThemeManager.shared)
            .preferredColorScheme(.dark)
    }
}



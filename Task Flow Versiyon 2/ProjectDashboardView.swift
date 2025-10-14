import SwiftUI

struct ProjectDashboardView: View {
    @State private var selectedTab: ProjectStatus = .todo
    @State private var projects = Project.sampleProjects
    
    var filteredProjects: [Project] {
        projects.filter { $0.status == selectedTab }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dark background
                Color(red: 0.11, green: 0.13, blue: 0.16)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            // Back action
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Proje Panosu")
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
                    
                    // Custom Tab Bar
                    HStack(spacing: 0) {
                        ForEach([ProjectStatus.todo, ProjectStatus.inProgress, ProjectStatus.completed], id: \.self) { tab in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTab = tab
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Text(tab.rawValue)
                                        .font(.system(size: 15))
                                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                                        .foregroundColor(selectedTab == tab ? Color.blue : Color.gray)
                                    
                                    // Bottom indicator
                                    Rectangle()
                                        .fill(selectedTab == tab ? Color.blue : Color.clear)
                                        .frame(height: 2)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // Projects List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredProjects) { project in
                                ProjectDashboardCard(project: project)
                                    .onTapGesture {
                                        // Navigate to project detail
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Project Dashboard Card
struct ProjectDashboardCard: View {
    let project: Project
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: project.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(project.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if !project.dueDateString.isEmpty {
                    Text(project.dueDateString)
                        .font(.system(size: 13))
                        .foregroundColor(Color.gray)
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
struct ProjectDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDashboardView()
            .preferredColorScheme(.dark)
    }
}

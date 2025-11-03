import SwiftUI

struct CreateProjectView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var projectManager: ProjectManager
    var onProjectCreated: ((Project) -> Void)?
    
    @State private var projectTitle: String = ""
    @State private var projectDescription: String = ""
    @State private var dueDate: Date = Date()
    @State private var selectedMembers: [User] = []
    @State private var selectedLeader: User?
    @State private var taskTitle: String = ""
    @State private var tasks: [String] = []
    @State private var showDatePicker = false
    @State private var showMemberPicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let availableMembers = User.sampleUsers
    
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
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Yeni Proje Oluştur")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Invisible button for balance
                    Image(systemName: "xmark")
                        .font(.title3)
                        .opacity(0)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Proje Başlığı
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Proje Başlığı")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            TextField("Örn: Web Sitesi Tasarımı", text: $projectTitle)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                        }
                        
                        // Proje Açıklaması
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Proje Açıklaması")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $projectDescription)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .frame(minHeight: 100)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                                .scrollContentBackground(.hidden)
                        }
                        
                        // Teslim Tarihi
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Teslim Tarihi")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Button(action: {
                                showDatePicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.blue)
                                    
                                    Text(formattedDate(dueDate))
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
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
                            
                            if showDatePicker {
                                DatePicker("", selection: $dueDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .colorScheme(.dark)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                    )
                            }
                        }
                        
                        // Ekip Üyeleri
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ekip Üyeleri")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            // Selected members
                            if !selectedMembers.isEmpty {
                                VStack(spacing: 8) {
                                    ForEach(selectedMembers) { member in
                                        HStack(spacing: 12) {
                                            Circle()
                                                .fill(Color.blue.opacity(0.3))
                                                .frame(width: 36, height: 36)
                                                .overlay(
                                                    Text(member.initials)
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundColor(.blue)
                                                )
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(member.displayName ?? "Unknown")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.white)
                                                
                                                Text(member.email ?? "")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                selectedMembers.removeAll { $0.id == member.id }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(red: 0.2, green: 0.22, blue: 0.26))
                                        )
                                    }
                                }
                            }
                            
                            // Add member button
                            Button(action: {
                                showMemberPicker.toggle()
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                    
                                    Text("Ekip Üyesi Ekle")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blue)
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue, lineWidth: 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                        )
                                )
                            }
                            
                            // Member picker
                            if showMemberPicker {
                                VStack(spacing: 8) {
                                    ForEach(availableMembers.filter { member in
                                        !selectedMembers.contains(where: { $0.id == member.id })
                                    }) { member in
                                        Button(action: {
                                            selectedMembers.append(member)
                                            showMemberPicker = false
                                        }) {
                                            HStack(spacing: 12) {
                                                Circle()
                                                    .fill(Color.blue.opacity(0.3))
                                                    .frame(width: 36, height: 36)
                                                    .overlay(
                                                        Text(member.initials)
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .foregroundColor(.blue)
                                                    )
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(member.displayName ?? "Unknown")
                                                        .font(.system(size: 14, weight: .medium))
                                                        .foregroundColor(.white)
                                                    
                                                    Text(member.email ?? "")
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.gray)
                                                }
                                                
                                                Spacer()
                                                
                                                Image(systemName: "plus.circle")
                                                    .foregroundColor(.blue)
                                            }
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color(red: 0.2, green: 0.22, blue: 0.26))
                                            )
                                        }
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                            }
                        }
                        
                        // Görevler
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Görevler")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            // Task list
                            if !tasks.isEmpty {
                                VStack(spacing: 8) {
                                    ForEach(Array(tasks.enumerated()), id: \.offset) { index, task in
                                        HStack(spacing: 12) {
                                            Image(systemName: "circle")
                                                .font(.system(size: 18))
                                                .foregroundColor(.gray)
                                            
                                            Text(task)
                                                .font(.system(size: 14))
                                                .foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                tasks.remove(at: index)
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color(red: 0.2, green: 0.22, blue: 0.26))
                                        )
                                    }
                                }
                            }
                            
                            // Add task
                            HStack(spacing: 12) {
                                TextField("Yeni görev ekle...", text: $taskTitle)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        addTask()
                                    }
                                
                                if !taskTitle.isEmpty {
                                    Button(action: {
                                        addTask()
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                            )
                        }
                        
                        // Create Button
                        Button(action: {
                            createProject()
                        }) {
                            Text("Kaydet ve Oluştur")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue)
                                )
                        }
                        .padding(.top, 20)
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Uyarı"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Tamam"))
            )
        }
    }
    
    // MARK: - Functions
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    private func addTask() {
        guard !taskTitle.isEmpty else { return }
        tasks.append(taskTitle)
        taskTitle = ""
    }
    
    private func createProject() {
        // Validation
        guard !projectTitle.isEmpty else {
            alertMessage = "Lütfen proje başlığını girin."
            showAlert = true
            return
        }
        
        guard !projectDescription.isEmpty else {
            alertMessage = "Lütfen proje açıklamasını girin."
            showAlert = true
            return
        }
        
        // Create tasks
        let projectTasks = tasks.enumerated().map { index, taskTitle in
            // TaskAssignee oluştur (geçici çözüm)
            let assigneeUser = selectedMembers.indices.contains(index % max(selectedMembers.count, 1)) ? selectedMembers[index % max(selectedMembers.count, 1)] : nil
            let taskAssignee = assigneeUser != nil ? TaskAssignee(
                name: assigneeUser?.displayName ?? "Unknown",
                avatarName: "",
                email: assigneeUser?.email ?? ""
            ) : nil
            
            return ProjectTask(
                title: taskTitle,
                description: "",
                assignee: taskAssignee,
                dueDate: dueDate,
                isCompleted: false
            )
        }
        
        // Create new project
        let newProject = Project(
            title: projectTitle,
            description: projectDescription,
            iconName: "list.bullet",
            iconColor: "blue",
            status: .todo,
            dueDate: dueDate,
            tasks: projectTasks,
            teamLeader: selectedLeader ?? selectedMembers.first,
            teamMembers: selectedMembers
        )
        
        // Save to Firestore
        Task {
            do {
                try await projectManager.createProject(newProject)
                
                // Notify parent view about new project
                onProjectCreated?(newProject)
                
                // Close view
                await MainActor.run {
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                alertMessage = "Proje oluşturulamadı: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

// MARK: - Preview
struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView()
            .environmentObject(ProjectManager())
            .preferredColorScheme(.dark)
    }
}

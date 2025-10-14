import SwiftUI

struct TaskDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var task: Task
    @State private var newComment: String = ""
    @FocusState private var isCommentFieldFocused: Bool
    
    init(task: Task = Task.sampleTask) {
        _task = State(initialValue: task)
    }
    
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
                    
                    Text("Task Details")
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
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Title Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            TextField("Task title", text: $task.title)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                        }
                        
                        // Description Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $task.description)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .frame(minHeight: 120)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                                .scrollContentBackground(.hidden)
                        }
                        
                        // Assignee Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Assignee")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            if let assignee = task.assignee {
                                HStack(spacing: 12) {
                                    // Avatar
                                    Circle()
                                        .fill(Color.orange.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.orange)
                                        )
                                    
                                    Text(assignee.name)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                )
                            }
                        }
                        
                        // Due Date Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Due Date")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .foregroundColor(.gray)
                                
                                Text(task.dueDateString)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                            )
                        }
                        
                        // Comments Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Comments")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            // Comments list
                            ForEach(task.comments) { comment in
                                CommentCard(comment: comment)
                            }
                            
                            // Add comment section
                            HStack(alignment: .center, spacing: 12) {
                                // Avatar
                                Circle()
                                    .fill(Color.orange.opacity(0.3))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.orange)
                                    )
                                
                                // Text field
                                TextField("Add a comment...", text: $newComment)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
                                    )
                                    .focused($isCommentFieldFocused)
                                    .submitLabel(.send)
                                    .onSubmit {
                                        addComment()
                                    }
                                
                                // Send button
                                if !newComment.isEmpty {
                                    Button(action: {
                                        addComment()
                                    }) {
                                        Image(systemName: "arrow.up.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(.blue)
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
    }
    
    private func addComment() {
        guard !newComment.isEmpty else { return }
        
        let comment = TaskComment(
            author: task.assignee ?? Task.sampleAssignees[0],
            content: newComment,
            createdDate: Date()
        )
        
        task.comments.append(comment)
        newComment = ""
        isCommentFieldFocused = false
    }
}

// MARK: - Comment Card
struct CommentCard: View {
    let comment: TaskComment
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Avatar
            Circle()
                .fill(Color.orange.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.orange)
                )
            
            // Comment content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(comment.author.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text(comment.dateString)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Text(comment.content)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(4)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.15, green: 0.17, blue: 0.21))
            )
        }
    }
}

// MARK: - Preview
struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView()
            .preferredColorScheme(.dark)
    }
}

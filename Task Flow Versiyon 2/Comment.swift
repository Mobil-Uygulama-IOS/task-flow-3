//
//  Comment.swift
//  Raptiye
//
//  Created on 16 Ekim 2025.
//

import Foundation

/// Yorum modeli - Android Comment.kt ile aynı
struct Comment: Identifiable, Codable {
    let id: String
    let text: String
    let author: User
    let createdDate: Date
    
    /// Formatlanmış tarih
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: createdDate)
    }
    
    init(id: String = UUID().uuidString, text: String, author: User, createdDate: Date = Date()) {
        self.id = id
        self.text = text
        self.author = author
        self.createdDate = createdDate
    }
}

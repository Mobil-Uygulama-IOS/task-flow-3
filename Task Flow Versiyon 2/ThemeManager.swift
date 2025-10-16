//
//  ThemeManager.swift
//  Raptiye
//
//  Created on 16 Ekim 2025.
//

import SwiftUI
import Combine

/// Tema Yöneticisi - Açık/Koyu tema kontrolü
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    static let shared = ThemeManager()
    
    init() {
        // Varsayılan olarak koyu tema
        self.isDarkMode = UserDefaults.standard.object(forKey: "isDarkMode") as? Bool ?? true
    }
    
    /// Temayı değiştir
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
    // Tema renkleri
    var backgroundColor: Color {
        isDarkMode ? Color(red: 0.11, green: 0.13, blue: 0.16) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    var cardBackground: Color {
        isDarkMode ? Color(red: 0.15, green: 0.17, blue: 0.21) : Color.white
    }
    
    var textColor: Color {
        isDarkMode ? .white : Color(red: 0.11, green: 0.13, blue: 0.16)
    }
    
    var secondaryTextColor: Color {
        isDarkMode ? .gray : Color(red: 0.4, green: 0.4, blue: 0.4)
    }
    
    var searchBackground: Color {
        isDarkMode ? Color(red: 0.15, green: 0.17, blue: 0.21) : Color(red: 0.9, green: 0.9, blue: 0.92)
    }
}

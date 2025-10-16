// LocalizationManager.swift
// Raptiye

import Foundation
import SwiftUI
import Combine

final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    @Published var currentLocale: Locale = Locale(identifier: "tr") {
        didSet {
            UserDefaults.standard.set(currentLocale.identifier, forKey: "app_locale")
        }
    }
    
    private init() {
        if let id = UserDefaults.standard.string(forKey: "app_locale") {
            currentLocale = Locale(identifier: id)
        } else {
            currentLocale = Locale(identifier: "tr")
        }
    }
    
    func localizedString(_ key: String) -> String {
        let bundlePath = Bundle.main.path(forResource: currentLocale.identifier, ofType: "lproj") ?? Bundle.main.bundlePath
        let bundle = Bundle(path: bundlePath) ?? Bundle.main
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}

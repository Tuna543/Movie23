//
//  ThemeManager.swift
//  Movie23
//
//  Created by BS00880 on 11/7/24.
//

import Foundation
import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {
        initDarkMode()
    }
    
    func initDarkMode() {
        if UserDefaults.standard.object(forKey: "isDarkMode") == nil {
            UserDefaults.standard.set(false, forKey: "isDarkMode")
        }
        applyTheme(isDarkMode: UserDefaults.standard.bool(forKey: "isDarkMode"))
    }
    
    var isDarkMode: Bool {
        return UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleDarkMode() {
        let newMode = !isDarkMode
        UserDefaults.standard.set(newMode, forKey: "isDarkMode")
        applyTheme(isDarkMode: newMode)
    }
    
    private func applyTheme(isDarkMode: Bool) {
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
}

extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}

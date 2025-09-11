//
//  ThemeManager.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import UIKit

enum ThemeMode: String, CaseIterable {
    case system, light, dark

    var displayName: String {
        switch self {
        case .system: return Strings.Settings.themeSystem
        case .light:  return Strings.Settings.themeLight
        case .dark:   return Strings.Settings.themeDark
        }
    }

    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

final class ThemeManager {
    static let shared = ThemeManager()
    private init() {}

    static let didChangeNotification = Notification.Name("ThemeManager.didChange")

    private(set) var mode: ThemeMode = .system

    func load(from settings: AppSettings) {
        self.mode = settings.themeMode
    }

    func update(mode: ThemeMode, settings: AppSettings) {
        settings.themeMode = mode
        self.mode = mode
        NotificationCenter.default.post(name: ThemeManager.didChangeNotification, object: nil)
    }

    func apply(to window: UIWindow?) {
        window?.overrideUserInterfaceStyle = mode.interfaceStyle
        // Personalizações globais opcionais:
        UINavigationBar.appearance().tintColor = Colors.accent
        UITabBar.appearance().tintColor = Colors.primary
    }
}

//
//  appsettings.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class AppSettings {
    private let defaults: UserDefaults

    private enum Keys {
        static let notificationsEnabled = "settings.notificationsEnabled"
        static let use24hClock = "settings.use24hClock"
        static let themeMode = "settings.themeMode"
        static let healthEnabled = "settings.healthEnabled"
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if defaults.string(forKey: Keys.themeMode) == nil {
            defaults.set(ThemeMode.system.rawValue, forKey: Keys.themeMode)
        }
    }

    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }

    var use24hClock: Bool {
        get { defaults.bool(forKey: Keys.use24hClock) }
        set { defaults.set(newValue, forKey: Keys.use24hClock) }
    }

    var themeMode: ThemeMode {
        get { ThemeMode(rawValue: defaults.string(forKey: Keys.themeMode) ?? ThemeMode.system.rawValue) ?? .system }
        set { defaults.set(newValue.rawValue, forKey: Keys.themeMode) }
    }

    var healthEnabled: Bool {
        get { defaults.bool(forKey: Keys.healthEnabled) }
        set { defaults.set(newValue, forKey: Keys.healthEnabled) }
    }
}

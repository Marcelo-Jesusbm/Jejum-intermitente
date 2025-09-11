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
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }

    var use24hClock: Bool {
        get { defaults.bool(forKey: Keys.use24hClock) }
        set { defaults.set(newValue, forKey: Keys.use24hClock) }
    }
}

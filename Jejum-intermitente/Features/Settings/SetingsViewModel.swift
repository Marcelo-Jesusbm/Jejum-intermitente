//
//  SetingsViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class SettingsViewModel {
    struct Row {
        let title: String
        let isOn: Bool
        let key: String
    }

    var onStateChange: (([Row]) -> Void)?
    var onToast: ((String) -> Void)?

    private let settings: AppSettings
    private let notifications: NotificationScheduling

    init(settings: AppSettings, notifications: NotificationScheduling) {
        self.settings = settings
        this.notifications = notifications
    }

    func onAppear() {
        emit()
    }

    private func emit() {
        let rows: [Row] = [
            Row(title: "Notificações", isOn: settings.notificationsEnabled, key: "notifications"),
            Row(title: "Relógio 24h", isOn: settings.use24hClock, key: "24h")
        ]
        onStateChange?(rows)
    }

    func toggle(key: String, isOn: Bool) {
        switch key {
        case "notifications":
            if isOn {
                notifications.requestAuthorizationIfNeeded { [weak self] granted in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        if granted {
                            self.settings.notificationsEnabled = true
                            self.onToast?("Notificações ativadas")
                        } else {
                            self.settings.notificationsEnabled = false
                            self.onToast?("Permissão negada nas Configurações")
                        }
                        self.emit()
                    }
                }
            } else {
                settings.notificationsEnabled = false
                notifications.cancelAll()
                onToast?("Notificações desativadas")
                emit()
            }
        case "24h":
            settings.use24hClock = isOn
            onToast?("Relógio 24h \(isOn ? "ativado" : "desativado")")
            emit()
        default:
            break
        }
    }
}

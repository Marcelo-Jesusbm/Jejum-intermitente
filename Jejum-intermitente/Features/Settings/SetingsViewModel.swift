//
//  SetingsViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

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

    init(settings: AppSettings) {
        self.settings = settings
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
            settings.notificationsEnabled = isOn
            onToast?("Notificações \(isOn ? "ativadas" : "desativadas")")
        case "24h":
            settings.use24hClock = isOn
            onToast?("Relógio 24h \(isOn ? "ativado" : "desativado")")
        default:
            break
        }
        emit()
    }
}

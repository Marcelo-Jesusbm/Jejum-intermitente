//
//  SetingsViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class SettingsViewModel {
    enum Row {
        case toggle(title: String, isOn: Bool, key: String)
        case option(title: String, value: String, key: String)
        case action(title: String, key: String)
    }

    var onStateChange: (([Row]) -> Void)?
    var onToast: ((String) -> Void)?
    var onExportReady: ((Data) -> Void)?

    private let settings: AppSettings
    private let notifications: NotificationScheduling

    // Backup
    private let exportJSON: ExportHistoryJSONUseCase
    private let importJSON: ImportHistoryJSONUseCase

    init(
        settings: AppSettings,
        notifications: NotificationScheduling,
        exportJSON: ExportHistoryJSONUseCase,
        importJSON: ImportHistoryJSONUseCase
    ) {
        self.settings = settings
        self.notifications = notifications
        self.exportJSON = exportJSON
        self.importJSON = importJSON
    }

    func onAppear() { emit() }

    private func emit() {
        let rows: [Row] = [
            .toggle(title: Strings.Settings.notifications, isOn: settings.notificationsEnabled, key: "notifications"),
            .toggle(title: Strings.Settings.clock24h, isOn: settings.use24hClock, key: "24h"),
            .option(title: Strings.Settings.theme, value: settings.themeMode.displayName, key: "theme"),
            .action(title: Strings.Settings.export_json, key: "export_json"),
            .action(title: Strings.Settings.import_json, key: "import_json")
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
                            self.onToast?(Strings.Settings.notifOn)
                        } else {
                            self.settings.notificationsEnabled = false
                            self.onToast?(Strings.Settings.notifDenied)
                        }
                        self.emit()
                    }
                }
            } else {
                settings.notificationsEnabled = false
                notifications.cancelAll()
                onToast?(Strings.Settings.notifOff)
                emit()
            }
        case "24h":
            settings.use24hClock = isOn
            onToast?(isOn ? Strings.Settings.clockOn : Strings.Settings.clockOff)
            emit()
        default: break
        }
    }

    func selectTheme(_ mode: ThemeMode) {
        ThemeManager.shared.update(mode: mode, settings: settings)
        emit()
    }

    func performAction(key: String) {
        switch key {
        case "export_json":
            DispatchQueue.global(qos: .userInitiated).async {
                let data = (try? self.exportJSON.execute()) ?? Data()
                DispatchQueue.main.async { self.onExportReady?(data) }
            }
        default:
            break
        }
    }

    func importFromJSONData(_ data: Data, completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let msg: String
            if let result = try? self.importJSON.execute(data: data) {
                msg = String(format: Strings.settings_import_result,
                             result.imported, result.updated, result.skipped)
            } else {
                msg = Strings.settings_import_failed
            }
            DispatchQueue.main.async {
                completion(msg)
                self.emit()
            }
        }
    }
}

// MARK: - Localized string helpers for VM keys
private extension Strings.Settings {
    static var export_json: String { NSLocalizedString("settings.export.json", comment: "") }
    static var import_json: String { NSLocalizedString("settings.import.json", comment: "") }
    static var import_result: String { NSLocalizedString("settings.import.result", comment: "") }
    static var import_failed: String { NSLocalizedString("settings.import.failed", comment: "") }
}
private extension Strings {
    static var settings_import_result: String { NSLocalizedString("settings.import.result", comment: "") }
    static var settings_import_failed: String { NSLocalizedString("settings.import.failed", comment: "") }
}

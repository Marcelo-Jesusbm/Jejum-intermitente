//
//  Strings.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

enum Strings {
    static func t(_ key: String, _ args: CVarArg...) -> String {
        let fmt = NSLocalizedString(key, comment: "")
        return String(format: fmt, arguments: args)
    }

    enum Tab {
        static var today: String { NSLocalizedString("tab.today", comment: "") }
        static var history: String { NSLocalizedString("tab.history", comment: "") }
        static var plans: String { NSLocalizedString("tab.plans", comment: "") }
        static var settings: String { NSLocalizedString("tab.settings", comment: "") }
    }

    enum Today {
        static var title: String { NSLocalizedString("today.title", comment: "") }
        static func planDefault(_ name: String) -> String { t("today.plan.default", name) }
        static func planCurrent(_ name: String) -> String { t("today.plan.current", name) }
        static var startBtn: String { NSLocalizedString("today.start", comment: "") }
        static var stopBtn: String { NSLocalizedString("today.stop", comment: "") }
        static var started: String { NSLocalizedString("today.started", comment: "") }
        static var startedMsg: String { NSLocalizedString("today.started.msg", comment: "") }
        static var stopped: String { NSLocalizedString("today.stopped", comment: "") }
        static var stoppedMsg: String { NSLocalizedString("today.stopped.msg", comment: "") }
        static func startTime(_ time: String) -> String { t("today.start.time", time) }
        static func elapsed(_ text: String) -> String { t("today.elapsed", text) }
        static func remaining(_ text: String) -> String { t("today.remaining", text) }
    }

    enum History {
        static var title: String { NSLocalizedString("history.title", comment: "") }
        static var header: String { NSLocalizedString("history.header", comment: "") }
        static var last14: String { NSLocalizedString("history.last14", comment: "") }
        static var export: String { NSLocalizedString("history.export", comment: "") }
        static var error: String { NSLocalizedString("history.refresh.error", comment: "") }

        enum Filters {
            static var title: String { NSLocalizedString("history.filters.title", comment: "") }
            static var all: String { NSLocalizedString("history.filters.all", comment: "") }
            static var active: String { NSLocalizedString("history.filters.active", comment: "") }
            static var finished: String { NSLocalizedString("history.filters.finished", comment: "") }
            static var clearPlan: String { NSLocalizedString("history.filters.clearPlan", comment: "") }
            static var cancel: String { NSLocalizedString("history.filters.cancel", comment: "") }
        }
    }

    enum Plans {
        static var title: String { NSLocalizedString("plans.title", comment: "") }
        static var updated: String { NSLocalizedString("plans.updated", comment: "") }
    }

    enum Settings {
        static var title: String { NSLocalizedString("settings.title", comment: "") }
        static var notifications: String { NSLocalizedString("settings.notifications", comment: "") }
        static var clock24h: String { NSLocalizedString("settings.clock24h", comment: "") }
        static var theme: String { NSLocalizedString("settings.theme", comment: "") }
        static var themeSystem: String { NSLocalizedString("settings.theme.system", comment: "") }
        static var themeLight: String { NSLocalizedString("settings.theme.light", comment: "") }
        static var themeDark: String { NSLocalizedString("settings.theme.dark", comment: "") }
        static var notifOn: String { NSLocalizedString("settings.notifications.on", comment: "") }
        static var notifOff: String { NSLocalizedString("settings.notifications.off", comment: "") }
        static var notifDenied: String { NSLocalizedString("settings.notifications.denied", comment: "") }
        static var clockOn: String { NSLocalizedString("settings.clock.on", comment: "") }
        static var clockOff: String { NSLocalizedString("settings.clock.off", comment: "") }
        static var on: String { NSLocalizedString("settings.toast.on", comment: "") }
        static var off: String { NSLocalizedString("settings.toast.off", comment: "") }
    }

    enum SessionDetail {
        static var title: String { NSLocalizedString("session.detail.title", comment: "") }
        static func plan(_ name: String) -> String { t("session.detail.plan", name) }
        static func start(_ date: String) -> String { t("session.detail.start", date) }
        static var endRunning: String { NSLocalizedString("session.detail.end.running", comment: "") }
        static func end(_ date: String) -> String { t("session.detail.end", date) }
        static func duration(_ d: String) -> String { t("session.detail.duration", d) }
        static var adjustEnd: String { NSLocalizedString("session.detail.adjust.end", comment: "") }
        static var save: String { NSLocalizedString("session.detail.save", comment: "") }
        static var stopNow: String { NSLocalizedString("session.detail.stop.now", comment: "") }
        static var delete: String { NSLocalizedString("session.detail.delete", comment: "") }
        static var saved: String { NSLocalizedString("session.detail.saved", comment: "") }
        static var savedMsg: String { NSLocalizedString("session.detail.saved.msg", comment: "") }
        static var deleteAsk: String { NSLocalizedString("session.detail.delete.ask", comment: "") }
        static var deleteWarn: String { NSLocalizedString("session.detail.delete.warn", comment: "") }
    }

    enum Common {
        static var cancel: String { NSLocalizedString("common.cancel", comment: "") }
        static var ok: String { NSLocalizedString("common.ok", comment: "") }
        static var error: String { NSLocalizedString("common.error", comment: "") }
    }

    enum Notifications {
        static var endTitle: String { NSLocalizedString("notifications.end.title", comment: "") }
        static func endBody(_ emoji: String, _ planName: String) -> String { t("notifications.end.body", emoji, planName) }
        static var stopAction: String { NSLocalizedString("notifications.action.stop", comment: "") }
    }
}

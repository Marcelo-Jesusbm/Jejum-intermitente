//
//  NotificationScheduling.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import UserNotifications

public protocol NotificationScheduling {
    func registerCategories()
    func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void)
    func scheduleEndOfFastNotification(for session: FastingSession)
    func cancelEndOfFastNotification(sessionId: UUID)
    func cancelAll()
}

public final class UserNotificationsScheduler: NSObject, NotificationScheduling {
    private let center: UNUserNotificationCenter

    // Categorias/Ações
    private let categoryId = "FASTING_CATEGORY"
    private let stopActionId = "STOP_FAST"

    public override init() {
        self.center = .current()
        super.init()
    }

    public func registerCategories() {
        let stop = UNNotificationAction(
            identifier: stopActionId,
            title: "Parar Jejum",
            options: [.authenticationRequired, .foreground]
        )
        let category = UNNotificationCategory(
            identifier: categoryId,
            actions: [stop],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        center.setNotificationCategories([category])
    }

    public func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                    completion(granted)
                }
            case .denied:
                completion(false)
            case .authorized, .provisional, .ephemeral:
                completion(true)
            @unknown default:
                completion(false)
            }
        }
    }

    public func scheduleEndOfFastNotification(for session: FastingSession) {
        registerCategories()

        // Calcula intervalo até o fim previsto
        let now = Date()
        let endDate = session.startDate.addingTimeInterval(session.goalDuration)
        let interval = endDate.timeIntervalSince(now)
        guard interval > 1 else { return } // evita agendar atrasado/zero

        let content = UNMutableNotificationContent()
        content.title = "Jejum concluído"
        content.body = "\(session.planEmoji) Seu jejum \(session.planName) atingiu a meta!"
        content.sound = .default
        content.categoryIdentifier = categoryId
        content.userInfo = [
            "type": "end_of_fast",
            "sessionId": session.id.uuidString
        ]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(
            identifier: endFastIdentifier(for: session.id),
            content: content,
            trigger: trigger
        )
        center.add(request, withCompletionHandler: nil)
    }

    public func cancelEndOfFastNotification(sessionId: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: [endFastIdentifier(for: sessionId)])
    }

    public func cancelAll() {
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
    }

    private func endFastIdentifier(for id: UUID) -> String {
        "end_fast_\(id.uuidString)"
    }
}

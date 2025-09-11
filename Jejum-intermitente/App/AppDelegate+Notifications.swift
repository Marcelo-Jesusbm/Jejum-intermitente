//
//  AppDelegate+Notifications.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func setupNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }

    // Notificações em foreground: exibir como banner/alerta
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }

    // Respostas a ações (ex.: Parar Jejum)
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        defer { completionHandler() }

        let userInfo = response.notification.request.content.userInfo
        if let type = userInfo["type"] as? String, type == "end_of_fast" {
            if response.actionIdentifier == "STOP_FAST" {
                // Para o jejum ativo ao tocar ação
                guard let container = AppEnvironment.shared.container else { return }
                _ = try? container.stopFast.execute()
            }
        }
    }
}

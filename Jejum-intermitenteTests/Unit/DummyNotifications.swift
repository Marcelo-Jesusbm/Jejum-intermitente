//
//  DummyNotifications.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation
@testable import Jejum_intermitente

final class DummyNotifications: NotificationScheduling {
    func registerCategories() {}
    func requestAuthorizationIfNeeded(completion: @escaping (Bool) -> Void) { completion(true) }
    func scheduleEndOfFastNotification(for session: FastingSession) {}
    func cancelEndOfFastNotification(sessionId: UUID) {}
    func cancelAll() {}
}

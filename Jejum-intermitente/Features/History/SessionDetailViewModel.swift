//
//  SessionDetailViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

final class SessionDetailViewModel {
    // Outputs
    struct UIState {
        let title: String
        let planLine: String
        let startLine: String
        let endLine: String
        let durationLine: String
        let isActive: Bool
    }

    var onState: ((UIState) -> Void)?
    var onError: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    var onDidChange: (() -> Void)?

    // Deps
    private let sessionId: UUID
    private let getSessionById: GetSessionByIdUseCase
    private let updateEndDate: UpdateSessionEndDateUseCase
    private let deleteSession: DeleteSessionUseCase
    private let stopFast: StopFastUseCase
    private let notifications: NotificationScheduling

    // State
    private var session: FastingSession?

    init(
        sessionId: UUID,
        getSessionById: GetSessionByIdUseCase,
        updateEndDate: UpdateSessionEndDateUseCase,
        deleteSession: DeleteSessionUseCase,
        stopFast: StopFastUseCase,
        notifications: NotificationScheduling
    ) {
        self.sessionId = sessionId
        self.getSessionById = getSessionById
        self.updateEndDate = updateEndDate
        self.deleteSession = deleteSession
        self.stopFast = stopFast
        self.notifications = notifications
    }

    func onAppear() {
        do {
            guard let s = try getSessionById.execute(id: sessionId) else {
                onError?("Sessão não encontrada.")
                onDismiss?()
                return
            }
            self.session = s
            emitState()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    private func emitState() {
        guard let s = session else { return }
        let start = DateFormatterHelper.dateTimeShort(from: s.startDate)
        let end = s.endDate != nil ? DateFormatterHelper.dateTimeShort(from: s.endDate!) : "—"
        let duration = s.elapsed(at: s.endDate ?? Date())
        let ui = UIState(
            title: s.planName,
            planLine: "\(s.planEmoji) Plano: \(s.planName)",
            startLine: "Início: \(start)",
            endLine: s.isActive ? "Fim: em andamento" : "Fim: \(end)",
            durationLine: "Duração: \(TimeFormatter.hms(duration))",
            isActive: s.isActive
        )
        onState?(ui)
    }

    func stopNow() {
        do {
            let stopped = try stopFast.execute()
            notifications.cancelEndOfFastNotification(sessionId: stopped.id)
            self.session = stopped
            emitState()
            onDidChange?()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    func saveEndDate(_ newDate: Date) {
        do {
            let updated = try updateEndDate.execute(id: sessionId, newEndDate: newDate)
            self.session = updated
            emitState()
            onDidChange?()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    func deleteCurrent() {
        do {
            if let s = session, s.isActive {
                notifications.cancelEndOfFastNotification(sessionId: s.id)
            }
            try deleteSession.execute(id: sessionId)
            onDidChange?()
            onDismiss?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

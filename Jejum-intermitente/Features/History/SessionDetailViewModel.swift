//
//  SessionDetailViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

final class SessionDetailViewModel {
    struct UIState {
        let title: String
        let planLine: String
        let startLine: String
        let endLine: String
        let durationLine: String
        let isActive: Bool
        let startDate: Date
        let endDate: Date?
    }

    var onState: ((UIState) -> Void)?
    var onError: ((String) -> Void)?
    var onDismiss: (() -> Void)?
    var onDidChange: (() -> Void)?

    private let sessionId: UUID
    private let getSessionById: GetSessionByIdUseCase
    private let updateEndDate: UpdateSessionEndDateUseCase
    private let deleteSession: DeleteSessionUseCase
    private let stopFast: StopFastUseCase
    private let notifications: NotificationScheduling
    private let health: HealthStoreManaging
    private let settings: AppSettings = AppEnvironment.shared.container.settings

    private var session: FastingSession?

    init(
        sessionId: UUID,
        getSessionById: GetSessionByIdUseCase,
        updateEndDate: UpdateSessionEndDateUseCase,
        deleteSession: DeleteSessionUseCase,
        stopFast: StopFastUseCase,
        notifications: NotificationScheduling,
        health: HealthStoreManaging
    ) {
        self.sessionId = sessionId
        self.getSessionById = getSessionById
        self.updateEndDate = updateEndDate
        self.deleteSession = deleteSession
        self.stopFast = stopFast
        self.notifications = notifications
        self.health = health
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
        let use24h = settings.use24hClock
        let startText = DateFormatterHelper.dateTimeShort(from: s.startDate, use24h: use24h)
        let endText = s.endDate != nil ? DateFormatterHelper.dateTimeShort(from: s.endDate!, use24h: use24h) : "—"
        let duration = s.elapsed(at: s.endDate ?? Date())
        let ui = UIState(
            title: s.planName,
            planLine: Strings.SessionDetail.plan(s.planName),
            startLine: Strings.SessionDetail.start(startText),
            endLine: s.isActive ? Strings.SessionDetail.endRunning : Strings.SessionDetail.end(endText),
            durationLine: Strings.SessionDetail.duration(TimeFormatter.hms(duration)),
            isActive: s.isActive,
            startDate: s.startDate,
            endDate: s.endDate
        )
        onState?(ui)
    }

    func stopNow() {
        do {
            let stopped = try stopFast.execute()
            notifications.cancelEndOfFastNotification(sessionId: stopped.id)
            self.session = stopped
            // HealthKit: gravar ao parar
            if settings.healthEnabled, let end = stopped.endDate {
                health.requestAuthorizationIfNeeded { [weak self] granted in
                    guard let self else { return }
                    if granted {
                        self.health.upsertFastingSession(
                            sessionId: stopped.id,
                            start: stopped.startDate,
                            end: end,
                            planName: stopped.planName,
                            planEmoji: stopped.planEmoji,
                            completion: nil
                        )
                    }
                }
            }
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
            // HealthKit: regrava amostra com novo fim
            if settings.healthEnabled, let end = updated.endDate {
                health.requestAuthorizationIfNeeded { [weak self] granted in
                    guard let self else { return }
                    if granted {
                        self.health.upsertFastingSession(
                            sessionId: updated.id,
                            start: updated.startDate,
                            end: end,
                            planName: updated.planName,
                            planEmoji: updated.planEmoji,
                            completion: nil
                        )
                    }
                }
            }
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
            // HealthKit: apagar amostra associada
            if settings.healthEnabled {
                health.deleteFastingSession(sessionId: sessionId, completion: nil)
            }
            onDidChange?()
            onDismiss?()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

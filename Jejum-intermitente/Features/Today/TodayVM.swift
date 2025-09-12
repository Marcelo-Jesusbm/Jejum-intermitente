//
//  TodayVM.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 12/09/25.
//

import Foundation
import UIKit

final class TodayViewModel {
    struct UIState {
        let isFasting: Bool
        let planLine: String
        let startLine: String
        let elapsedText: String
        let remainingText: String
        let progress: Double
        let buttonTitle: String
    }

    var onStateChange: ((UIState) -> Void)?
    var onStartFast: (() -> Void)?
    var onStopFast: (() -> Void)?
    var onError: ((String) -> Void)?

    private let getActiveSession: GetActiveSessionUseCase
    private let startFast: StartFastUseCase
    private let stopFast: StopFastUseCase
    private let getDefaultPlan: GetDefaultPlanUseCase
    private let clock: Clock
    private let tickerFactory: () -> Ticker
    private let settings: AppSettings
    private let notifications: NotificationScheduling

    private(set) var activeSession: FastingSession?
    private var ticker: Ticker?
    private var lifecycleObservers: [NSObjectProtocol] = []
    private let notificationCenter: NotificationCenter

    init(
        getActiveSession: GetActiveSessionUseCase,
        startFast: StartFastUseCase,
        stopFast: StopFastUseCase,
        getDefaultPlan: GetDefaultPlanUseCase,
        clock: Clock,
        tickerFactory: @escaping () -> Ticker,
        settings: AppSettings,
        notifications: NotificationScheduling,
        notificationCenter: NotificationCenter = .default
    ) {
        self.getActiveSession = getActiveSession
        self.startFast = startFast
        self.stopFast = stopFast
        self.getDefaultPlan = getDefaultPlan
        self.clock = clock
        self.tickerFactory = tickerFactory
        self.settings = settings
        self.notifications = notifications
        self.notificationCenter = notificationCenter
        observeLifecycle()
    }

    deinit {
        stopTicker()
        lifecycleObservers.forEach { notificationCenter.removeObserver($0) }
        lifecycleObservers.removeAll()
    }

    var isFasting: Bool { activeSession != nil }

    func onAppear() {
        do {
            self.activeSession = try getActiveSession.execute()
            if isFasting { startTickerIfNeeded() }
            emitState()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    func toggleFast() {
        isFasting ? stop() : start()
    }

    private func start() {
        do {
            _ = getDefaultPlan.execute()
            let session = try startFast.execute(.init())
            self.activeSession = session
            if settings.notificationsEnabled {
                notifications.requestAuthorizationIfNeeded { [weak self] granted in
                    guard let self else { return }
                    if granted {
                        self.notifications.scheduleEndOfFastNotification(for: session)
                    }
                }
            }
            onStartFast?()
            startTickerIfNeeded()
            emitState()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    private func stop() {
        do {
            let stopped = try stopFast.execute()
            if settings.notificationsEnabled {
                notifications.cancelEndOfFastNotification(sessionId: stopped.id)
            }
            self.activeSession = nil
            onStopFast?()
            stopTicker()
            emitState()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    private func emitState() {
        let now = clock.now()
        let use24h = settings.use24hClock
        if let s = activeSession {
            let elapsed = s.elapsed(at: now)
            let remaining = s.remaining(at: now)
            let progress = s.progress(at: now)
            let state = UIState(
                isFasting: true,
                planLine: Strings.Today.planCurrent(s.planName),
                startLine: Strings.Today.startTime(DateFormatterHelper.timeShort(from: s.startDate, use24h: use24h)),
                elapsedText: Strings.Today.elapsed(TimeFormatter.hms(elapsed)),
                remainingText: Strings.Today.remaining(TimeFormatter.hms(remaining)),
                progress: progress,
                buttonTitle: Strings.Today.stopBtn
            )
            onStateChange?(state)
        } else {
            let defaultPlan = getDefaultPlan.execute()
            let state = UIState(
                isFasting: false,
                planLine: Strings.Today.planDefault(defaultPlan.name),
                startLine: Strings.Today.startTime("—"),
                elapsedText: Strings.Today.elapsed(TimeFormatter.hms(0)),
                remainingText: Strings.Today.remaining(TimeFormatter.hms(defaultPlan.fastingDuration)),
                progress: 0,
                buttonTitle: Strings.Today.startBtn
            )
            onStateChange?(state)
        }
    }

    private func startTickerIfNeeded() {
        guard ticker?.isRunning != true else { return }
        let t = tickerFactory()
        self.ticker = t
        t.start(interval: 1.0) { [weak self] in
            self?.emitState()
        }
    }

    private func stopTicker() {
        ticker?.stop()
        ticker = nil
    }

    private func observeLifecycle() {
        let willResign = notificationCenter.addObserver(
            forName: UIApplication.willResignActiveNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?.stopTicker()
        }
        let didBecome = notificationCenter.addObserver(
            forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            if self.isFasting { self.startTickerIfNeeded() }
            self.emitState()
        }
        lifecycleObservers.append(contentsOf: [willResign, didBecome])
    }
}

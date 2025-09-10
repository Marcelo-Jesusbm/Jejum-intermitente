

//
//  HomeViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import UIKit

final class TodayViewModel {
    // Saídas
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

    // Casos de uso
    private let getActiveSession: GetActiveSessionUseCase
    private let startFast: StartFastUseCase
    private let stopFast: StopFastUseCase
    private let getDefaultPlan: GetDefaultPlanUseCase
    private let clock: Clock
    private let tickerFactory: () -> Ticker

    // Estado atual
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
        notificationCenter: NotificationCenter = .default
    ) {
        self.getActiveSession = getActiveSession
        self.startFast = startFast
        self.stopFast = stopFast
        self.getDefaultPlan = getDefaultPlan
        self.clock = clock
        self.tickerFactory = tickerFactory
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
        if isFasting {
            stop()
        } else {
            start()
        }
    }

    private func start() {
        do {
            _ = getDefaultPlan.execute() // futuro: permitir seleção
            let session = try startFast.execute(.init())
            self.activeSession = session
            onStartFast?()
            startTickerIfNeeded()
            emitState()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    private func stop() {
        do {
            _ = try stopFast.execute()
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
        if let s = activeSession {
            let elapsed = s.elapsed(at: now)
            let remaining = s.remaining(at: now)
            let progress = s.progress(at: now)
            let state = UIState(
                isFasting: true,
                planLine: "\(s.planEmoji) Plano: \(s.planName)",
                startLine: "Início: \(DateFormatterHelper.timeShort(from: s.startDate))",
                elapsedText: "Decorridos: \(TimeFormatter.hms(elapsed))",
                remainingText: "Restantes: \(TimeFormatter.hms(remaining))",
                progress: progress,
                buttonTitle: "Parar Jejum"
            )
            onStateChange?(state)
        } else {
            let defaultPlan = getDefaultPlan.execute()
            let state = UIState(
                isFasting: false,
                planLine: "\(defaultPlan.emoji) Plano padrão: \(defaultPlan.name)",
                startLine: "Início: —",
                elapsedText: "Decorridos: 00:00:00",
                remainingText: "Restantes: \(TimeFormatter.hms(defaultPlan.fastingDuration))",
                progress: 0,
                buttonTitle: "Iniciar Jejum"
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

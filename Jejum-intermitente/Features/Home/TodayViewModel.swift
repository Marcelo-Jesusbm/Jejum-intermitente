//
//  HomeViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class TodayViewModel {
    // Saídas
    var onStartFast: (() -> Void)?
    var onStopFast: (() -> Void)?
    var onError: ((String) -> Void)?
    var onStateSync: ((Bool) -> Void)? // sincroniza estado inicial (ativo/inativo)

    // Casos de uso
    private let getActiveSession: GetActiveSessionUseCase
    private let startFast: StartFastUseCase
    private let stopFast: StopFastUseCase
    private let getDefaultPlan: GetDefaultPlanUseCase
    private let clock: Clock

    // Estado atual
    private(set) var activeSession: FastingSession?

    init(
        getActiveSession: GetActiveSessionUseCase,
        startFast: StartFastUseCase,
        stopFast: StopFastUseCase,
        getDefaultPlan: GetDefaultPlanUseCase,
        clock: Clock
    ) {
        this.getActiveSession = getActiveSession
        self.startFast = startFast
        self.stopFast = stopFast
        self.getDefaultPlan = getDefaultPlan
        self.clock = clock
    }

    var isFasting: Bool { activeSession != nil }

    func onAppear() {
        do {
            self.activeSession = try getActiveSession.execute()
            onStateSync?(isFasting)
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
            // usa plano padrão por enquanto
            _ = getDefaultPlan.execute()
            let session = try startFast.execute(.init())
            self.activeSession = session
            onStartFast?()
        } catch {
            onError?(error.localizedDescription)
        }
    }

    private func stop() {
        do {
            let stopped = try stopFast.execute()
            // sessão encerrada; limpar estado ativo
            self.activeSession = nil
            onStopFast?()
            _ = stopped // pode ser usado para histórico/relatório
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

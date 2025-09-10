//
//  AppContainer.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class AppContainer {
    // Infra
    let clock: Clock
    let sessionRepo: FastingSessionRepository
    let planRepo: PlanRepository

    // Use cases
    lazy var getActiveSession = GetActiveSessionUseCase(sessionRepo: sessionRepo)
    lazy var startFast = StartFastUseCase(sessionRepo: sessionRepo, planRepo: planRepo, clock: clock)
    lazy var stopFast = StopFastUseCase(sessionRepo: sessionRepo, clock: clock)
    lazy var getHistory = GetHistoryUseCase(sessionRepo: sessionRepo)
    lazy var getAvailablePlans = GetAvailablePlansUseCase(planRepo: planRepo)
    lazy var getDefaultPlan = GetDefaultPlanUseCase(planRepo: planRepo)
    lazy var setDefaultPlan = SetDefaultPlanUseCase(planRepo: planRepo)

    init(clock: Clock, sessionRepo: FastingSessionRepository, planRepo: PlanRepository) {
        self.clock = clock
        self.sessionRepo = sessionRepo
        self.planRepo = planRepo
    }

    static func buildDefault() -> AppContainer {
        AppContainer(
            clock: SystemClock(),
            sessionRepo: InMemoryFastingSessionRepository(),
            planRepo: InMemoryPlanRepository()
        )
    }

    // Factories de ViewModel
    func makeTodayViewModel() -> TodayViewModel {
        TodayViewModel(
            getActiveSession: getActiveSession,
            startFast: startFast,
            stopFast: stopFast,
            getDefaultPlan: getDefaultPlan,
            clock: clock
        )
    }

    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel()
    }

    func makePlansViewModel() -> PlansViewModel {
        PlansViewModel()
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel()
    }
}

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
    let coreData: CoreDataStack
    let sessionRepo: FastingSessionRepository
    let planRepo: PlanRepository

    // Timer factory
    let tickerFactory: () -> Ticker

    // Settings
    let settings: AppSettings

    // Use cases
    lazy var getActiveSession = GetActiveSessionUseCase(sessionRepo: sessionRepo)
    lazy var startFast = StartFastUseCase(sessionRepo: sessionRepo, planRepo: planRepo, clock: clock)
    lazy var stopFast = StopFastUseCase(sessionRepo: sessionRepo, clock: clock)
    lazy var getHistory = GetHistoryUseCase(sessionRepo: sessionRepo)
    lazy var getAvailablePlans = GetAvailablePlansUseCase(planRepo: planRepo)
    lazy var getDefaultPlan = GetDefaultPlanUseCase(planRepo: planRepo)
    lazy var setDefaultPlan = SetDefaultPlanUseCase(planRepo: planRepo)

    init(
        clock: Clock,
        coreData: CoreDataStack,
        sessionRepo: FastingSessionRepository,
        planRepo: PlanRepository,
        tickerFactory: @escaping () -> Ticker,
        settings: AppSettings
    ) {
        self.clock = clock
        self.coreData = coreData
        self.sessionRepo = sessionRepo
        self.planRepo = planRepo
        self.tickerFactory = tickerFactory
        self.settings = settings
    }

    static func buildDefault(inMemory: Bool = false) -> AppContainer {
        let coreData = CoreDataStack(inMemory: inMemory)
        let sessionRepo = CoreDataFastingSessionRepository(coreData: coreData)
        let planRepo = CoreDataPlanRepository(coreData: coreData)

        return AppContainer(
            clock: SystemClock(),
            coreData: coreData,
            sessionRepo: sessionRepo,
            planRepo: planRepo,
            tickerFactory: { GCDTicker(queue: .main) },
            settings: AppSettings()
        )
    }

    // Factories de ViewModel
    func makeTodayViewModel() -> TodayViewModel {
        TodayViewModel(
            getActiveSession: getActiveSession,
            startFast: startFast,
            stopFast: stopFast,
            getDefaultPlan: getDefaultPlan,
            clock: clock,
            tickerFactory: tickerFactory
        )
    }

    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(getHistory: getHistory)
    }

    func makePlansViewModel() -> PlansViewModel {
        PlansViewModel(
            getAvailablePlans: getAvailablePlans,
            getDefaultPlan: getDefaultPlan,
            setDefaultPlan: setDefaultPlan
        )
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(settings: settings)
    }
}

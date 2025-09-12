//
//  TestContainerBuilder.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation
@testable import Jejum_intermitente

enum TestContainerBuilder {
    static func make(clock: Clock? = nil) -> AppContainer {
        let cd = CoreDataStack(inMemory: true)
        let sessionRepo = CoreDataFastingSessionRepository(coreData: cd)
        let planRepo = CoreDataPlanRepository(coreData: cd)
        let container = AppContainer(
            clock: clock ?? SystemClock(),
            coreData: cd,
            sessionRepo: sessionRepo,
            planRepo: planRepo,
            tickerFactory: { GCDTicker(queue: .main) },
            settings: AppSettings(),
            notifications: DummyNotifications()
        )
        AppEnvironment.shared.container = container
        return container
    }
}

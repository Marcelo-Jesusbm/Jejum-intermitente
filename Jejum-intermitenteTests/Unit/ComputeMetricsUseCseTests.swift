//
//  ComputeMetricsUseCseTests.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import XCTest
@testable import Jejum_intermitente

final class ComputeMetricsUseCaseTests: XCTestCase {

    func testMetricsAverageBestStreakAndSeries() throws {
        let cal = Calendar.current
        let base = Date() // hoje
        let container = TestContainerBuilder.make()
        let repo = container.sessionRepo

        // Helper para criar sessão finalizada
        func insertSession(hours: Double, endedAt end: Date) throws {
            let start = end.addingTimeInterval(-hours * 3600)
            let s = FastingSession(
                planId: BuiltinPlans.sixteenEight.id,
                planName: BuiltinPlans.sixteenEight.name,
                planEmoji: BuiltinPlans.sixteenEight.emoji,
                goalDuration: hours * 3600,
                startDate: start,
                endDate: end
            )
            try repo.update(s)
        }

        // Hoje: 10h, Ontem: 16h, Anteontem: 20h
        try insertSession(hours: 10, endedAt: base)
        let yesterday = cal.date(byAdding: .day, value: -1, to: base)!
        try insertSession(hours: 16, endedAt: yesterday)
        let twoDays = cal.date(byAdding: .day, value: -2, to: base)!
        try insertSession(hours: 20, endedAt: twoDays)

        let metrics = try container.computeMetrics.execute(daysWindow: 14)
        XCTAssertEqual(metrics.totalSessions, 3)
        XCTAssertEqual(Int(metrics.bestSeconds), Int(20 * 3600))
        XCTAssertEqual(Int(metrics.averageSeconds), Int((10+16+20)/3 * 3600), accuracy: 1)

        // Streak: hoje e ontem têm sessões => ao menos 2
        XCTAssertGreaterThanOrEqual(metrics.currentStreakDays, 2)

        // Série de 14 dias
        XCTAssertEqual(metrics.lastDaysDurationsHours.count, 14)
        // últimos 3 dias (aprox) devem ter > 0 horas em algum deles
        XCTAssertTrue(metrics.lastDaysDurationsHours.suffix(3).reduce(0, +) > 0)
    }
}

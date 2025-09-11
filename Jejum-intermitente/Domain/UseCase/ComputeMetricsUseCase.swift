//
//  ComputeMetricsUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct ComputeMetricsUseCase {
    private let sessionRepo: FastingSessionRepository
    private let calendar: Calendar

    public init(sessionRepo: FastingSessionRepository, calendar: Calendar = .current) {
        self.sessionRepo = sessionRepo
        self.calendar = calendar
    }

    public func execute(daysWindow: Int = 14) throws -> MetricsSummary {
        let all = try sessionRepo.fetchHistory(limit: nil, offset: 0)
        let completed = all.compactMap { s -> (start: Date, end: Date, duration: TimeInterval)? in
            guard let end = s.endDate else { return nil }
            return (start: s.startDate, end: end, duration: s.elapsed(at: end))
        }

        let totalSessions = completed.count
        let total = completed.reduce(0) { $0 + $1.duration }
        let average = totalSessions > 0 ? total / Double(totalSessions) : 0
        let best = completed.map(\.duration).max() ?? 0

        // Streak: dias consecutivos (a partir de hoje) com pelo menos 1 sessão encerrada
        let daysWithSession: Set<Date> = Set(completed.map { calendar.startOfDay(for: $0.end) })
        var streak = 0
        var cursor = calendar.startOfDay(for: Date())
        while daysWithSession.contains(cursor) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }

        // Série diária (últimos N dias, incluindo hoje)
        let lastDays = (0..<daysWindow).reversed().compactMap { offset -> Date? in
            calendar.date(byAdding: .day, value: -offset, to: calendar.startOfDay(for: Date()))
        }
        var durationsByDay: [Date: TimeInterval] = [:]
        for item in completed {
            let day = calendar.startOfDay(for: item.end)
            durationsByDay[day, default: 0] += item.duration
        }
        let hoursSeries = lastDays.map { day -> Double in
            let sec = durationsByDay[day] ?? 0
            return sec / 3600.0
        }

        return MetricsSummary(
            totalSessions: totalSessions,
            totalFastingSeconds: total,
            averageSeconds: average,
            bestSeconds: best,
            currentStreakDays: streak,
            lastDaysDurationsHours: hoursSeries
        )
    }
}

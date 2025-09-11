//
//  Metrics.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct MetricsSummary {
    public let totalSessions: Int
    public let totalFastingSeconds: TimeInterval
    public let averageSeconds: TimeInterval
    public let bestSeconds: TimeInterval
    public let currentStreakDays: Int
    public let lastDaysDurationsHours: [Double] // tamanho fixo, ex.: 14
}

//
//  FastingSession.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct FastingSession: Equatable, Identifiable {
    public let id: UUID
    public let planId: String
    public let planName: String
    public let planEmoji: String
    public let goalDuration: TimeInterval
    public let startDate: Date
    public var endDate: Date?

    public init(
        id: UUID = UUID(),
        planId: String,
        planName: String,
        planEmoji: String,
        goalDuration: TimeInterval,
        startDate: Date,
        endDate: Date? = nil
    ) {
        self.id = id
        self.planId = planId
        self.planName = planName
        self.planEmoji = planEmoji
        self.goalDuration = goalDuration
        self.startDate = startDate
        self.endDate = endDate
    }

    public var isActive: Bool { endDate == nil }

    public func elapsed(at date: Date = Date()) -> TimeInterval {
        let end = endDate ?? date
        return max(0, end.timeIntervalSince(startDate))
    }

    public func remaining(at date: Date = Date()) -> TimeInterval {
        max(0, goalDuration - elapsed(at: date))
    }

    public func progress(at date: Date = Date()) -> Double {
        guard goalDuration > 0 else { return 0 }
        return min(1, elapsed(at: date) / goalDuration)
    }

    public func stopping(at endDate: Date) -> FastingSession {
        var copy = self
        copy.endDate = endDate
        return copy
    }
}

//
//  BackupDTO.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

public struct BackupFileDTO: Codable {
    public let version: Int
    public let exportedAt: Date
    public let defaultPlanId: String
    public let sessions: [BackupSessionDTO]
}

public struct BackupSessionDTO: Codable {
    public let id: UUID
    public let planId: String
    public let planName: String
    public let planEmoji: String
    public let goalDuration: TimeInterval
    public let startDate: Date
    public let endDate: Date?

    public init(from s: FastingSession) {
        self.id = s.id
        self.planId = s.planId
        self.planName = s.planName
        self.planEmoji = s.planEmoji
        self.goalDuration = s.goalDuration
        self.startDate = s.startDate
        self.endDate = s.endDate
    }

    public func toDomain() -> FastingSession {
        FastingSession(
            id: id,
            planId: planId,
            planName: planName,
            planEmoji: planEmoji,
            goalDuration: goalDuration,
            startDate: startDate,
            endDate: endDate
        )
    }
}

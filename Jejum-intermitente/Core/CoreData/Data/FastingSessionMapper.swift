//
//  FastingSessionMapper.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import CoreData

enum FastingSessionMapper {
    static func toDomain(_ entity: FastingSessionEntity) -> FastingSession {
        FastingSession(
            id: entity.id,
            planId: entity.planId,
            planName: entity.planName,
            planEmoji: entity.planEmoji,
            goalDuration: entity.goalDuration,
            startDate: entity.startDate,
            endDate: entity.endDate
        )
    }

    static func apply(_ domain: FastingSession, into entity: FastingSessionEntity) {
        entity.id = domain.id
        entity.planId = domain.planId
        entity.planName = domain.planName
        entity.planEmoji = domain.planEmoji
        entity.goalDuration = domain.goalDuration
        entity.startDate = domain.startDate
        entity.endDate = domain.endDate
    }
}

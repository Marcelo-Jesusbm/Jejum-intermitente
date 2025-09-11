//
//  ExportHistoryJSONUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

public struct ExportHistoryJSONUseCase {
    private let sessionRepo: FastingSessionRepository
    private let planRepo: PlanRepository

    public init(sessionRepo: FastingSessionRepository, planRepo: PlanRepository) {
        self.sessionRepo = sessionRepo
        self.planRepo = planRepo
    }

    public func execute() throws -> Data {
        let sessions = try sessionRepo.fetchHistory(limit: nil, offset: 0)
        let dto = BackupFileDTO(
            version: 1,
            exportedAt: Date(),
            defaultPlanId: planRepo.getDefaultPlan().id,
            sessions: sessions.map(BackupSessionDTO.init(from:))
        )
        let enc = JSONCoder.encoder()
        return try enc.encode(dto)
    }
}

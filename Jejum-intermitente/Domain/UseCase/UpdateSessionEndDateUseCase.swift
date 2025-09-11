//
//  UpdateSessionEndDateUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

public struct UpdateSessionEndDateUseCase {
    private let sessionRepo: FastingSessionRepository
    public init(sessionRepo: FastingSessionRepository) { self.sessionRepo = sessionRepo }

    public func execute(id: UUID, newEndDate: Date) throws -> FastingSession {
        guard var session = try sessionRepo.fetchById(id) else {
            throw DomainError.invalidOperation("Sessão não encontrada.")
        }
        if newEndDate < session.startDate {
            throw DomainError.invalidOperation("Data de término anterior ao início.")
        }
        session.endDate = newEndDate
        try sessionRepo.update(session)
        return session
    }
}

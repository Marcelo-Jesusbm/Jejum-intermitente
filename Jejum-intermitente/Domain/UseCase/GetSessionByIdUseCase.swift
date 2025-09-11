//
//  GetSessionByIdUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

public struct GetSessionByIdUseCase {
    private let sessionRepo: FastingSessionRepository
    public init(sessionRepo: FastingSessionRepository) { self.sessionRepo = sessionRepo }
    public func execute(id: UUID) throws -> FastingSession? {
        try sessionRepo.fetchById(id)
    }
}

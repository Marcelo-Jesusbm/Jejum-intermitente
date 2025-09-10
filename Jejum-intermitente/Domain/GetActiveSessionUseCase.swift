//
//  GetActiveSessionUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct GetActiveSessionUseCase {
    private let sessionRepo: FastingSessionRepository

    public init(sessionRepo: FastingSessionRepository) {
        self.sessionRepo = sessionRepo
    }

    public func execute() throws -> FastingSession? {
        try sessionRepo.fetchActive()
    }
}

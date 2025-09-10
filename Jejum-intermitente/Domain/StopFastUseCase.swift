//
//  StopFastUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct StopFastUseCase {
    private let sessionRepo: FastingSessionRepository
    private let clock: Clock

    public init(sessionRepo: FastingSessionRepository, clock: Clock) {
        self.sessionRepo = sessionRepo
        self.clock = clock
    }

    @discardableResult
    public func execute() throws -> FastingSession {
        guard try sessionRepo.fetchActive() != nil else {
            throw DomainError.noActiveSession
        }
        let end = clock.now()
        return try sessionRepo.stopActive(endDate: end)
    }
}

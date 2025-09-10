//
//  GetHistoryUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct GetHistoryUseCase {
    private let sessionRepo: FastingSessionRepository

    public init(sessionRepo: FastingSessionRepository) {
        self.sessionRepo = sessionRepo
    }

    public func execute(limit: Int? = nil, offset: Int = 0) throws -> [FastingSession] {
        try sessionRepo.fetchHistory(limit: limit, offset: offset)
    }
}

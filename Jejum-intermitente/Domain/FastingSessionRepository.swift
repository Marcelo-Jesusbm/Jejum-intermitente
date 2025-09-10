//
//  FastingSessionRepository.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public protocol FastingSessionRepository {
    func fetchActive() throws -> FastingSession?
    func start(startDate: Date, plan: FastingPlan) throws -> FastingSession
    func stopActive(endDate: Date) throws -> FastingSession
    func update(_ session: FastingSession) throws
    func fetchHistory(limit: Int?, offset: Int) throws -> [FastingSession]
}

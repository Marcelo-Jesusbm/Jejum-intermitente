//
//  InMemoryFastingSessionRepository.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class InMemoryFastingSessionRepository: FastingSessionRepository {
    func fetchById(_ id: UUID) throws -> FastingSession? {
        
    }
    
    func delete(id: UUID) throws {
        
    }
    
    private var sessions: [FastingSession] = []

    func fetchActive() throws -> FastingSession? {
        sessions.first(where: { $0.endDate == nil })
    }

    func start(startDate: Date, plan: FastingPlan) throws -> FastingSession {
        if let _ = try fetchActive() {
            throw DomainError.activeSessionExists
        }
        let session = FastingSession(
            planId: plan.id,
            planName: plan.name,
            planEmoji: plan.emoji,
            goalDuration: plan.fastingDuration,
            startDate: startDate,
            endDate: nil
        )
        sessions.insert(session, at: 0)
        return session
    }

    func stopActive(endDate: Date) throws -> FastingSession {
        guard let idx = sessions.firstIndex(where: { $0.endDate == nil }) else {
            throw DomainError.noActiveSession
        }
        let stopped = sessions[idx].stopping(at: endDate)
        sessions[idx] = stopped
        return stopped
    }

    func update(_ session: FastingSession) throws {
        if let idx = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[idx] = session
        }
    }

    func fetchHistory(limit: Int?, offset: Int) throws -> [FastingSession] {
        let slice = sessions.dropFirst(offset)
        if let limit = limit { return Array(slice.prefix(limit)) }
        return Array(slice)
    }
}

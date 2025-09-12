//
//  InMemoryFastingSessionRepository.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class InMemoryFastingSessionRepository: FastingSessionRepository {
    private var store: [UUID: FastingSession] = [:]
    private let queue = DispatchQueue(label: "InMemoryFastingSessionRepository.queue", qos: .userInitiated)

    init(seed: [FastingSession] = []) {
        seed.forEach { store[$0.id] = $0 }
    }

    func fetchActive() throws -> FastingSession? {
        try queue.sync {
            store.values
                .filter { $0.endDate == nil }
                .sorted(by: { $0.startDate > $1.startDate })
                .first
        }
    }

    func start(startDate: Date, plan: FastingPlan) throws -> FastingSession {
        try queue.sync {
            if store.values.contains(where: { $0.endDate == nil }) {
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
            store[session.id] = session
            return session
        }
    }

    func stopActive(endDate: Date) throws -> FastingSession {
        try queue.sync {
            guard let active = store.values.first(where: { $0.endDate == nil }) else {
                throw DomainError.noActiveSession
            }
            var updated = active
            updated.endDate = endDate
            store[updated.id] = updated
            return updated
        }
    }

    // Upsert
    func update(_ session: FastingSession) throws {
        try queue.sync {
            store[session.id] = session
        }
    }

    func fetchHistory(limit: Int?, offset: Int) throws -> [FastingSession] {
        try queue.sync {
            var all = store.values.sorted(by: { $0.startDate > $1.startDate })
            if offset > 0 {
                all = Array(all.dropFirst(offset))
            }
            if let limit = limit {
                all = Array(all.prefix(limit))
            }
            return all
        }
    }

    func fetchById(_ id: UUID) throws -> FastingSession? {
        try queue.sync {
            store[id]
        }
    }

    func delete(id: UUID) throws {
        try queue.sync {
            store.removeValue(forKey: id)
        }
    }
}

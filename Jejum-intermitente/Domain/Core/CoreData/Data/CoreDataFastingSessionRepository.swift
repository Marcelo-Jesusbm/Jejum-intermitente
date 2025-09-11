//
//  CoreDataFastingSessionRepository.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import CoreData

final class CoreDataFastingSessionRepository: FastingSessionRepository {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack) {
        self.coreData = coreData
    }

    func fetchActive() throws -> FastingSession? {
        try coreData.performAndWait { ctx in
            let req: NSFetchRequest<FastingSessionEntity> = FastingSessionEntity.fetchRequest()
            req.predicate = NSPredicate(format: "endDate == nil")
            req.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
            req.fetchLimit = 1
            let results = try ctx.fetch(req)
            return results.first.map(FastingSessionMapper.toDomain)
        }
    }

    func start(startDate: Date, plan: FastingPlan) throws -> FastingSession {
        try coreData.performAndWait { ctx in
            // Impede sessões simultâneas
            let active = try self.fetchActive()
            if active != nil { throw DomainError.activeSessionExists }

            guard let entity = NSEntityDescription.insertNewObject(
                forEntityName: CoreDataModel.fastingSessionEntityName,
                into: ctx
            ) as? FastingSessionEntity else {
                throw DomainError.invalidOperation("Falha ao criar entidade de sessão.")
            }

            let domain = FastingSession(
                planId: plan.id,
                planName: plan.name,
                planEmoji: plan.emoji,
                goalDuration: plan.fastingDuration,
                startDate: startDate,
                endDate: nil
            )

            FastingSessionMapper.apply(domain, into: entity)
            try coreData.save(context: ctx)
            return FastingSessionMapper.toDomain(entity)
        }
    }

    func stopActive(endDate: Date) throws -> FastingSession {
        try coreData.performAndWait { ctx in
            let req: NSFetchRequest<FastingSessionEntity> = FastingSessionEntity.fetchRequest()
            req.predicate = NSPredicate(format: "endDate == nil")
            req.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
            req.fetchLimit = 1
            guard let entity = try ctx.fetch(req).first else {
                throw DomainError.noActiveSession
            }
            entity.endDate = endDate
            try coreData.save(context: ctx)
            return FastingSessionMapper.toDomain(entity)
        }
    }

    func update(_ session: FastingSession) throws {
        try coreData.performAndWait { ctx in
            let req: NSFetchRequest<FastingSessionEntity> = FastingSessionEntity.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", session.id as CVarArg)
            req.fetchLimit = 1
            guard let entity = try ctx.fetch(req).first else {
                // Se não encontrar, insere (upsert simples)
                guard let newEntity = NSEntityDescription.insertNewObject(
                    forEntityName: CoreDataModel.fastingSessionEntityName,
                    into: ctx
                ) as? FastingSessionEntity else {
                    throw DomainError.invalidOperation("Falha no upsert de sessão.")
                }
                FastingSessionMapper.apply(session, into: newEntity)
                try coreData.save(context: ctx)
                return
            }
            FastingSessionMapper.apply(session, into: entity)
            try coreData.save(context: ctx)
        }
    }

    func fetchHistory(limit: Int?, offset: Int) throws -> [FastingSession] {
        try coreData.performAndWait { ctx in
            let req: NSFetchRequest<FastingSessionEntity> = FastingSessionEntity.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
            if let limit = limit { req.fetchLimit = limit }
            req.fetchOffset = offset
            let results = try ctx.fetch(req)
            return results.map(FastingSessionMapper.toDomain)
        }
    }
}

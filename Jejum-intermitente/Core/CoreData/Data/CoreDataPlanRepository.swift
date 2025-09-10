//
//  CoreDataPlanRepository.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation
import CoreData

final class CoreDataPlanRepository: PlanRepository {
    private let coreData: CoreDataStack
    private let preferenceKey = "default"

    init(coreData: CoreDataStack) {
        self.coreData = coreData
    }

    func getAvailablePlans() -> [FastingPlan] {
        BuiltinPlans.all()
    }

    func getDefaultPlan() -> FastingPlan {
        let id = (try? getDefaultPlanId()) ?? BuiltinPlans.sixteenEight.id
        return BuiltinPlans.byId(id) ?? BuiltinPlans.sixteenEight
    }

    func setDefaultPlan(id: String) throws {
        guard BuiltinPlans.all().contains(where: { $0.id == id }) else {
            throw DomainError.planNotFound
        }
        try coreData.performAndWait { ctx in
            let req: NSFetchRequest<PlanPreferenceEntity> = PlanPreferenceEntity.fetchRequest()
            req.predicate = NSPredicate(format: "key == %@", preferenceKey)
            let entity = try ctx.fetch(req).first ?? {
                let new = NSEntityDescription.insertNewObject(
                    forEntityName: CoreDataModel.planPreferenceEntityName, into: ctx
                ) as! PlanPreferenceEntity
                new.key = preferenceKey
                return new
            }()
            entity.defaultPlanId = id
            try coreData.save(context: ctx)
        }
    }

    // MARK: - Helpers

    private func getDefaultPlanId() throws -> String {
        try coreData.performAndWait { ctx in
            let req: NSFetchRequest<PlanPreferenceEntity> = PlanPreferenceEntity.fetchRequest()
            req.predicate = NSPredicate(format: "key == %@", preferenceKey)
            req.fetchLimit = 1
            if let entity = try ctx.fetch(req).first {
                return entity.defaultPlanId
            } else {
                // Seed default
                let entity = NSEntityDescription.insertNewObject(
                    forEntityName: CoreDataModel.planPreferenceEntityName, into: ctx
                ) as! PlanPreferenceEntity
                entity.key = preferenceKey
                entity.defaultPlanId = BuiltinPlans.sixteenEight.id
                try coreData.save(context: ctx)
                return entity.defaultPlanId
            }
        }
    }
}

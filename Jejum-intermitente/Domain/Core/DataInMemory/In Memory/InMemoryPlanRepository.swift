//
//  InMemoryPlanRepository.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class InMemoryPlanRepository: PlanRepository {
    private var plans: [FastingPlan] = BuiltinPlans.all()
    private var defaultPlanId: String = BuiltinPlans.sixteenEight.id

    func getAvailablePlans() -> [FastingPlan] {
        plans
    }

    func getDefaultPlan() -> FastingPlan {
        plans.first(where: { $0.id == defaultPlanId }) ?? BuiltinPlans.sixteenEight
    }

    func setDefaultPlan(id: String) throws {
        guard plans.contains(where: { $0.id == id }) else {
            throw DomainError.planNotFound
        }
        defaultPlanId = id
    }
}

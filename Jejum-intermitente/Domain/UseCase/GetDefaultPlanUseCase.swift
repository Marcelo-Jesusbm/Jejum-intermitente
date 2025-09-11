//
//  GetDefaultPlanUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct GetDefaultPlanUseCase {
    private let planRepo: PlanRepository
    public init(planRepo: PlanRepository) { self.planRepo = planRepo }
    public func execute() -> FastingPlan { planRepo.getDefaultPlan() }
}

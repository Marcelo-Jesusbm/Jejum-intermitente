//
//  SetDefaultPlanUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct SetDefaultPlanUseCase {
    private let planRepo: PlanRepository
    public init(planRepo: PlanRepository) { self.planRepo = planRepo }
    public func execute(id: String) throws { try planRepo.setDefaultPlan(id: id) }
}

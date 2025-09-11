//
//  PlanRepository.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public protocol PlanRepository {
    func getAvailablePlans() -> [FastingPlan]
    func getDefaultPlan() -> FastingPlan
    func setDefaultPlan(id: String) throws
}

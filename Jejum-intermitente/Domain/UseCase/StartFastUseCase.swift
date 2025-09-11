//
//  StartFastUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct StartFastUseCase {
    private let sessionRepo: FastingSessionRepository
    private let planRepo: PlanRepository
    private let clock: Clock

    public init(sessionRepo: FastingSessionRepository, planRepo: PlanRepository, clock: Clock) {
        self.sessionRepo = sessionRepo
        self.planRepo = planRepo
        self.clock = clock
    }

    public struct Input {
        public let planId: String?
        public let customDuration: TimeInterval? // se fornecido, sobrescreve duração do plano
        public init(planId: String? = nil, customDuration: TimeInterval? = nil) {
            self.planId = planId
            self.customDuration = customDuration
        }
    }

    @discardableResult
    public func execute(_ input: Input = .init()) throws -> FastingSession {
        if try sessionRepo.fetchActive() != nil {
            throw DomainError.activeSessionExists
        }

        let basePlan: FastingPlan = {
            if let planId = input.planId, let p = planRepo.getAvailablePlans().first(where: { $0.id == planId }) {
                return p
            }
            return planRepo.getDefaultPlan()
        }()

        let effectivePlan: FastingPlan = {
            if let custom = input.customDuration {
                return FastingPlan(
                    id: "custom_\(Int(custom))",
                    name: "Personalizado",
                    emoji: "🧩",
                    fastingDuration: custom,
                    eatingDuration: 0
                )
            } else {
                return basePlan
            }
        }()

        let now = clock.now()
        let session = try sessionRepo.start(startDate: now, plan: effectivePlan)
        return session
    }
}

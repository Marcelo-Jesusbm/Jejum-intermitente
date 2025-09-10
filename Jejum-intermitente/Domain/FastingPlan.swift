//
//  FastingPlan.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

public struct FastingPlan: Equatable, Hashable {
    public let id: String          // ex.: "16_8", "18_6", "20_4", "custom"
    public let name: String        // ex.: "16:8 Leangains"
    public let emoji: String       // ex.: "⏱️"
    public let fastingDuration: TimeInterval
    public let eatingDuration: TimeInterval

    public init(id: String, name: String, emoji: String, fastingDuration: TimeInterval, eatingDuration: TimeInterval) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.fastingDuration = fastingDuration
        self.eatingDuration = eatingDuration
    }
}

public enum BuiltinPlans {
    public static let sixteenEight = FastingPlan(
        id: "16_8",
        name: "16:8 Leangains",
        emoji: "⏱️",
        fastingDuration: 16 * 3600,
        eatingDuration: 8 * 3600
    )

    public static let eighteenSix = FastingPlan(
        id: "18_6",
        name: "18:6",
        emoji: "⌛️",
        fastingDuration: 18 * 3600,
        eatingDuration: 6 * 3600
    )

    public static let twentyFourWarrior = FastingPlan(
        id: "20_4",
        name: "20:4 (Warrior)",
        emoji: "🛡️",
        fastingDuration: 20 * 3600,
        eatingDuration: 4 * 3600
    )

    public static func all() -> [FastingPlan] {
        [sixteenEight, eighteenSix, twentyFourWarrior]
    }

    public static func byId(_ id: String) -> FastingPlan? {
        all().first(where: { $0.id == id })
    }
}

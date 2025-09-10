//
//  PlansViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class PlansViewModel {
    struct Row {
        let id: String
        let emoji: String
        let title: String
        let subtitle: String
        let isSelected: Bool
    }

    var onStateChange: (([Row]) -> Void)?
    var onError: ((String) -> Void)?
    var onDidSelect: ((String) -> Void)?

    private let getAvailablePlans: GetAvailablePlansUseCase
    private let getDefaultPlan: GetDefaultPlanUseCase
    private let setDefaultPlan: SetDefaultPlanUseCase

    private var plans: [FastingPlan] = []
    private var selectedId: String?

    init(
        getAvailablePlans: GetAvailablePlansUseCase,
        getDefaultPlan: GetDefaultPlanUseCase,
        setDefaultPlan: SetDefaultPlanUseCase
    ) {
        self.getAvailablePlans = getAvailablePlans
        self.getDefaultPlan = getDefaultPlan
        self.setDefaultPlan = setDefaultPlan
    }

    func onAppear() {
        plans = getAvailablePlans.execute()
        selectedId = getDefaultPlan.execute().id
        emit()
    }

    private func emit() {
        let rows = plans.map { p in
            Row(
                id: p.id,
                emoji: p.emoji,
                title: p.name,
                subtitle: "Janela de jejum: \(Int(p.fastingDuration/3600))h • Alimentação: \(Int(p.eatingDuration/3600))h",
                isSelected: p.id == selectedId
            )
        }
        onStateChange?(rows)
    }

    func didSelectPlan(id: String) {
        do {
            try setDefaultPlan.execute(id: id)
            selectedId = id
            emit()
            onDidSelect?(id)
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

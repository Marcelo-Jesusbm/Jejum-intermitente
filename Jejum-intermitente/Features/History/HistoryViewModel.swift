//
//  HistoryViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

import Foundation

final class HistoryViewModel {
    struct Row {
        let id: UUID
        let title: String       // Ex.: "⏱️ 16:8 Leangains"
        let subtitle: String    // Ex.: "Início 14:20 • Fim 06:45" ou "Início 14:20 • Em andamento"
        let trailing: String    // Ex.: "16:23:10"
        let isActive: Bool
    }

    var onStateChange: (([Row]) -> Void)?
    var onError: ((String) -> Void)?

    private let getHistory: GetHistoryUseCase

    init(getHistory: GetHistoryUseCase) {
        self.getHistory = getHistory
    }

    func onAppear() {
        reload()
    }

    func reload() {
        do {
            let sessions = try getHistory.execute(limit: nil, offset: 0)
            let rows = sessions.map { s -> Row in
                let start = DateFormatterHelper.timeShort(from: s.startDate)
                let end: String
                let elapsed: TimeInterval
                if let endDate = s.endDate {
                    end = DateFormatterHelper.timeShort(from: endDate)
                    elapsed = s.elapsed(at: endDate)
                } else {
                    end = "Em andamento"
                    elapsed = s.elapsed()
                }
                return Row(
                    id: s.id,
                    title: "\(s.planEmoji) \(s.planName)",
                    subtitle: "Início \(start) • \(s.endDate == nil ? end : "Fim \(end)")",
                    trailing: TimeFormatter.hms(elapsed),
                    isActive: s.isActive
                )
            }
            onStateChange?(rows)
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

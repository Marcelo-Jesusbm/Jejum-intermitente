//
//  HistoryViewModel.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class HistoryViewModel {
    struct Row {
        let id: UUID
        let title: String
        let subtitle: String
        let trailing: String
        let isActive: Bool
        let planId: String
    }

    enum StatusFilter { case all, active, finished }

    var onStateChange: (([Row]) -> Void)?
    var onError: ((String) -> Void)?
    var onMetrics: ((MetricsSummary) -> Void)?
    var onOpenSession: ((UUID) -> Void)?

    private let getHistory: GetHistoryUseCase
    private let computeMetrics: ComputeMetricsUseCase
    private let exportCSV: ExportHistoryCSVUseCase
    private let settings: AppSettings = AppEnvironment.shared.container.settings

    private var allRows: [Row] = []
    private(set) var appliedStatus: StatusFilter = .all
    private(set) var appliedPlanId: String? = nil

    init(getHistory: GetHistoryUseCase, computeMetrics: ComputeMetricsUseCase, exportCSV: ExportHistoryCSVUseCase) {
        self.getHistory = getHistory
        self.computeMetrics = computeMetrics
        self.exportCSV = exportCSV
    }

    func onAppear() { reload() }

    func reload() {
        do {
            let use24h = settings.use24hClock
            let sessions = try getHistory.execute(limit: nil, offset: 0)
            allRows = sessions.map { s in
                let start = DateFormatterHelper.timeShort(from: s.startDate, use24h: use24h)
                let end: String
                let elapsed: TimeInterval
                if let endDate = s.endDate {
                    end = DateFormatterHelper.timeShort(from: endDate, use24h: use24h)
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
                    isActive: s.isActive,
                    planId: s.planId
                )
            }
            applyFiltersAndEmit()

            let summary = try computeMetrics.execute(daysWindow: 14)
            onMetrics?(summary)
        } catch {
            onError?(error.localizedDescription)
        }
    }

    private func applyFiltersAndEmit() {
        var rows = allRows
        switch appliedStatus {
        case .all: break
        case .active: rows = rows.filter { $0.isActive }
        case .finished: rows = rows.filter { !$0.isActive }
        }
        if let plan = appliedPlanId {
            rows = rows.filter { $0.planId == plan }
        }
        onStateChange?(rows)
    }

    func setStatusFilter(_ filter: StatusFilter) {
        appliedStatus = filter
        applyFiltersAndEmit()
    }

    func setPlanFilter(planId: String?) {
        appliedPlanId = planId
        applyFiltersAndEmit()
    }

    func didSelectRow(at index: Int, in rows: [Row]) {
        onOpenSession?(rows[index].id)
    }

    func buildCSV(completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let result = (try? self.exportCSV.execute()) ?? ""
            DispatchQueue.main.async { completion(result) }
        }
    }
}

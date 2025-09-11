//
//  ExportHistoryCSVUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

public struct ExportHistoryCSVUseCase {
    private let sessionRepo: FastingSessionRepository
    private let iso: ISO8601DateFormatter

    public init(sessionRepo: FastingSessionRepository) {
        self.sessionRepo = sessionRepo
        self.iso = ISO8601DateFormatter()
        self.iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    }

    public func execute() throws -> String {
        let sessions = try sessionRepo.fetchHistory(limit: nil, offset: 0)
        var lines: [String] = []
        lines.append("id,planId,planName,startDate,endDate,goalSeconds,durationSeconds,active")
        for s in sessions {
            let start = iso.string(from: s.startDate)
            let end = s.endDate != nil ? iso.string(from: s.endDate!) : ""
            let duration = s.elapsed(at: s.endDate ?? Date())
            let line = [
                s.id.uuidString,
                s.planId,
                s.planName.replacingOccurrences(of: ",", with: " "),
                start,
                end,
                String(Int(s.goalDuration)),
                String(Int(duration)),
                s.isActive ? "1" : "0"
            ].joined(separator: ",")
            lines.append(line)
        }
        return lines.joined(separator: "\n")
    }
}

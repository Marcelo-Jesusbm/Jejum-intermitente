//
//  ImportHistoryJSONUseCase.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import Foundation

public struct ImportHistoryJSONUseCase {
    public struct Result: Equatable {
        public let imported: Int
        public let updated: Int
        public let skipped: Int
    }

    private let sessionRepo: FastingSessionRepository
    private let setDefaultPlan: SetDefaultPlanUseCase

    public init(sessionRepo: FastingSessionRepository, setDefaultPlan: SetDefaultPlanUseCase) {
        self.sessionRepo = sessionRepo
        self.setDefaultPlan = setDefaultPlan
    }

    public func execute(data: Data) throws -> Result {
        let dec = JSONCoder.decoder()
        let file = try dec.decode(BackupFileDTO.self, from: data)

        // Restaura plano padrão (ignora erro se ID não existe)
        try? setDefaultPlan.execute(id: file.defaultPlanId)

        var imported = 0, updated = 0, skipped = 0

        // Evita conflito de sessão ativa: se já há ativa, sessões ativas do arquivo serão ignoradas
        let hasActive = (try? sessionRepo.fetchActive()) ?? nil

        for dto in file.sessions {
            var domain = dto.toDomain()
            if dto.endDate == nil, hasActive != nil {
                // pular sessões ativas do arquivo caso já exista uma ativa localmente
                skipped += 1
                continue
            }
            // Upsert: update() já faz insert se não existir
            if let existing = try sessionRepo.fetchById(dto.id) {
                // Atualiza se houver diferença
                if existing != domain {
                    try sessionRepo.update(domain)
                    updated += 1
                } else {
                    skipped += 1
                }
            } else {
                try sessionRepo.update(domain)
                imported += 1
            }
        }

        return Result(imported: imported, updated: updated, skipped: skipped)
    }
}

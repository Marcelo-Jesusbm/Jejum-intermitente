//
//  DomainError.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

enum DomainError: Error, LocalizedError, Equatable {
    case activeSessionExists
    case noActiveSession
    case planNotFound
    case invalidOperation(String)

    var errorDescription: String? {
        switch self {
        case .activeSessionExists:
            return "Já existe um jejum em andamento."
        case .noActiveSession:
            return "Não há jejum em andamento."
        case .planNotFound:
            return "Plano de jejum não encontrado."
        case .invalidOperation(let msg):
            return msg
        }
    }
}

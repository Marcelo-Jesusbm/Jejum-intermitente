//
//  AppEnvironment.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import Foundation

final class AppEnvironment {
    static let shared = AppEnvironment()
    private init() {}

    // Tornamos acessível para AppDelegate responder a ações de notificação
    var container: AppContainer!
}

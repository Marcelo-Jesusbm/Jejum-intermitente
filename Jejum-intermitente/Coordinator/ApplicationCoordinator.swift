//
//  ApplicationCoordinator.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    private let container: AppContainer
    private let tabBarCoordinator: TabBarCoordinator

    init(window: UIWindow) {
        self.window = window
        self.container = AppContainer.buildDefault(inMemory: false)
        AppEnvironment.shared.container = container
        self.tabBarCoordinator = TabBarCoordinator(container: container)
    }

    func start() {
        window.rootViewController = tabBarCoordinator.rootViewController
        tabBarCoordinator.start()
    }
}

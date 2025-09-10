//
//  SettingsCoordinator.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    let navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(
            title: "Ajustes",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        return nav
    }()

    func start() {
        let vm = container.makeSettingsViewModel()
        let vc = SettingsViewController(viewModel: vm)
        vc.title = "Ajustes"
        navigationController.setViewControllers([vc], animated: false)
    }
}

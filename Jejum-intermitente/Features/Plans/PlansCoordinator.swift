//
//  PlansCoordinator.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class PlansCoordinator: Coordinator {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    let navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(
            title: "Planos",
            image: UIImage(systemName: "list.bullet.rectangle"),
            selectedImage: UIImage(systemName: "list.bullet.rectangle.fill")
        )
        return nav
    }()

    func start() {
        let vm = container.makePlansViewModel()
        let vc = PlansViewController(viewModel: vm)
        vc.title = "Planos"
        navigationController.setViewControllers([vc], animated: false)
    }
}

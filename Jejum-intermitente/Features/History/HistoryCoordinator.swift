//
//  HistoryCoordinator.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class HistoryCoordinator: Coordinator {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    let navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(
            title: "Histórico",
            image: UIImage(systemName: "chart.bar.doc.horizontal"),
            selectedImage: UIImage(systemName: "chart.bar.doc.horizontal.fill")
        )
        return nav
    }()

    func start() {
        let vm = container.makeHistoryViewModel()
        let vc = HistoryViewController(viewModel: vm)
        vc.title = "Histórico"
        navigationController.setViewControllers([vc], animated: false)
    }
}

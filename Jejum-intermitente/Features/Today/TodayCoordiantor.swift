//
//  TodayCoordiantor.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class TodayCoordinator: Coordinator {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    let navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = UITabBarItem(
            title: Strings.Tab.today,
            image: UIImage(systemName: "clock"),
            selectedImage: UIImage(systemName: "clock.fill")
        )
        return nav
    }()

    func start() {
        let vm = container.makeTodayViewModel()
        let vc = TodayViewController(viewModel: vm)
        vc.title = Strings.Tab.today
        navigationController.setViewControllers([vc], animated: false)
    }
}

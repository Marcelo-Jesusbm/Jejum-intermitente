//
//  TabBarCoordinator.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//
import UIKit

final class TabBarCoordinator: Coordinator {
    let tabBarController: UITabBarController
    private let container: AppContainer

    private let todayCoordinator: TodayCoordinator
    private let historyCoordinator: HistoryCoordinator
    private let plansCoordinator: PlansCoordinator
    private let settingsCoordinator: SettingsCoordinator

    var rootViewController: UITabBarController { tabBarController }

    init(container: AppContainer) {
        self.container = container
        self.tabBarController = UITabBarController()
        self.tabBarController.tabBar.tintColor = Colors.primary
        self.tabBarController.tabBar.isTranslucent = false

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }

        self.todayCoordinator = TodayCoordinator(container: container)
        self.historyCoordinator = HistoryCoordinator(container: container)
        self.plansCoordinator = PlansCoordinator(container: container)
        self.settingsCoordinator = SettingsCoordinator(container: container)
    }

    func start() {
        todayCoordinator.start()
        historyCoordinator.start()
        plansCoordinator.start()
        settingsCoordinator.start()

        tabBarController.setViewControllers(
            [
                todayCoordinator.navigationController,
                historyCoordinator.navigationController,
                plansCoordinator.navigationController,
                settingsCoordinator.navigationController
            ],
            animated: false
        )
    }
}

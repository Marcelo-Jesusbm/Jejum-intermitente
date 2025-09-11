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

    private var historyVM: HistoryViewModel?

    func start() {
        let vm = container.makeHistoryViewModel()
        vm.onOpenSession = { [weak self] id in
            self?.showDetail(sessionId: id)
        }
        let vc = HistoryViewController(viewModel: vm)
        vc.title = "Histórico"
        navigationController.setViewControllers([vc], animated: false)
        self.historyVM = vm
    }

    private func showDetail(sessionId: UUID) {
        let vm = container.makeSessionDetailViewModel(sessionId: sessionId)
        // Ao salvar/excluir, recarrega histórico
        vm.onDidChange = { [weak self] in
            self?.historyVM?.reload()
        }
        let vc = SessionDetailViewController(viewModel: vm)
        navigationController.pushViewController(vc, animated: true)
    }
}

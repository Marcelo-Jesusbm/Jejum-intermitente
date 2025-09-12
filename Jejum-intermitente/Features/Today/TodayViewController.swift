//
//  HomeViewController.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//
import UIKit

final class TodayViewController: BaseViewController<TodayView> {
    private let viewModel: TodayViewModel

    init(viewModel: TodayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        contentView.actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        viewModel.onAppear()
    }

    private func setupBindings() {
        viewModel.onStateChange = { [weak self] state in
            self?.contentView.update(state: state)
        }

        viewModel.onStartFast = { [weak self] in
            guard let self else { return }
            Haptics.success()
            UIAccessibility.post(notification: .announcement, argument: Strings.Today.started)
            let alert = UIAlertController(title: Strings.Today.started, message: Strings.Today.startedMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
            self.present(alert, animated: true)
        }

        viewModel.onStopFast = { [weak self] in
            guard let self else { return }
            Haptics.success()
            UIAccessibility.post(notification: .announcement, argument: Strings.Today.stopped)
            let alert = UIAlertController(title: Strings.Today.stopped, message: Strings.Today.stoppedMsg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
            self.present(alert, animated: true)
        }

        viewModel.onError = { [weak self] message in
            Haptics.error()
            let alert = UIAlertController(title: Strings.Common.error, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Strings.Common.ok, style: .default))
            self?.present(alert, animated: true)
        }
    }

    @objc private func didTapAction() {
        Haptics.lightImpact()
        viewModel.toggleFast()
    }
}

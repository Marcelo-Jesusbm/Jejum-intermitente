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
        contentView.update(isFasting: false)
        viewModel.onAppear()
    }

    private func setupBindings() {
        viewModel.onStartFast = { [weak self] in
            self?.contentView.update(isFasting: true)
            let alert = UIAlertController(title: "Jejum iniciado", message: "Boa sorte! 🍀", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.onStopFast = { [weak self] in
            self?.contentView.update(isFasting: false)
            let alert = UIAlertController(title: "Jejum finalizado", message: "Ótimo trabalho! 💪", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ops", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }

        viewModel.onStateSync = { [weak self] isFasting in
            self?.contentView.update(isFasting: isFasting)
        }
    }

    @objc private func didTapAction() {
        viewModel.toggleFast()
    }
}

//
//  SessionDetailViewController.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import UIKit

final class SessionDetailViewController: BaseViewController<SessionDetailView> {
    private let viewModel: SessionDetailViewModel

    init(viewModel: SessionDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        contentView.saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        contentView.stopButton.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        contentView.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)

        viewModel.onAppear()
    }

    private func setupBindings() {
        viewModel.onState = { [weak self] state in
            guard let self else { return }
            self.title = state.title
            self.contentView.planLabel.text = state.planLine
            self.contentView.startLabel.text = state.startLine
            self.contentView.endLabel.text = state.endLine
            self.contentView.durationLabel.text = state.durationLine
            self.contentView.configure(
                isActive: state.isActive,
                startDate: nil,
                endDate: nil
            )
        }
        viewModel.onError = { [weak self] msg in
            let alert = UIAlertController(title: "Erro", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        viewModel.onDismiss = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    @objc private func saveTapped() {
        let date = contentView.endDatePicker.date
        viewModel.saveEndDate(date)
        let alert = UIAlertController(title: "Salvo", message: "Fim ajustado.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func stopTapped() {
        viewModel.stopNow()
    }

    @objc private func deleteTapped() {
        let alert = UIAlertController(title: "Excluir sessão?", message: "Esta ação não pode ser desfeita.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Excluir", style: .destructive, handler: { _ in
            self.viewModel.deleteCurrent()
        }))
        present(alert, animated: true)
    }
}

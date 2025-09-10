//
//  HistoryViewController.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class HistoryViewController: BaseViewController<HistoryView> {
    private let viewModel: HistoryViewModel
    private var rows: [HistoryViewModel.Row] = []

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always

        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        contentView.refresh.addTarget(self, action: #selector(reload), for: .valueChanged)

        viewModel.onAppear()
    }

    private func setupBindings() {
        viewModel.onStateChange = { [weak self] rows in
            guard let self else { return }
            self.rows = rows
            self.contentView.tableView.reloadData()
            self.contentView.refresh.endRefreshing()
        }
        viewModel.onError = { [weak self] msg in
            self?.contentView.refresh.endRefreshing()
            let alert = UIAlertController(title: "Erro", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }

    @objc private func reload() {
        viewModel.reload()
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
        cell.fill(with: rows[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Futuro: navegar para detalhes da sessão
    }
}

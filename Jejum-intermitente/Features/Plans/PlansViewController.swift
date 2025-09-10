//
//  PlansViewController.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class PlansViewController: BaseViewController<PlansView> {
    private let viewModel: PlansViewModel
    private var rows: [PlansViewModel.Row] = []

    init(viewModel: PlansViewModel) {
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
        viewModel.onAppear()
    }

    private func setupBindings() {
        viewModel.onStateChange = { [weak self] rows in
            self?.rows = rows
            self?.contentView.tableView.reloadData()
        }
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Erro", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        viewModel.onDidSelect = { [weak self] _ in
            let alert = UIAlertController(title: "Plano padrão atualizado", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension PlansViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanCell.reuseId, for: indexPath) as! PlanCell
        cell.fill(with: rows[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = rows[indexPath.row].id
        viewModel.didSelectPlan(id: id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

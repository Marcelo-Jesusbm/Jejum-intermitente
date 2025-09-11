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

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Exportar", style: .plain, target: self, action: #selector(exportCSV)),
            UIBarButtonItem(title: "Filtros", style: .plain, target: self, action: #selector(showFilters))
        ]

        viewModel.onAppear()
    }

    private func setupBindings() {
        viewModel.onStateChange = { [weak self] rows in
            guard let self else { return }
            self.rows = rows
            self.contentView.tableView.reloadData()
            self.contentView.refresh.endRefreshing()
        }
        viewModel.onMetrics = { [weak self] summary in
            self?.contentView.updateHeader(with: summary)
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

    @objc private func exportCSV() {
        viewModel.buildCSV { [weak self] csv in
            guard let self else { return }
            let vc = UIActivityViewController(activityItems: [csv], applicationActivities: nil)
            vc.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItems?.first
            self.present(vc, animated: true)
        }
    }

    @objc private func showFilters() {
        let sheet = UIAlertController(title: "Filtros", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Todos", style: .default, handler: { _ in
            self.viewModel.setStatusFilter(.all); self.viewModel.setPlanFilter(planId: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Ativos", style: .default, handler: { _ in
            self.viewModel.setStatusFilter(.active)
        }))
        sheet.addAction(UIAlertAction(title: "Concluídos", style: .default, handler: { _ in
            self.viewModel.setStatusFilter(.finished)
        }))
        // Filtros por plano
        BuiltinPlans.all().forEach { plan in
            sheet.addAction(UIAlertAction(title: plan.name, style: .default, handler: { _ in
                self.viewModel.setPlanFilter(planId: plan.id)
            }))
        }
        sheet.addAction(UIAlertAction(title: "Limpar plano", style: .destructive, handler: { _ in
            self.viewModel.setPlanFilter(planId: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        if let pop = sheet.popoverPresentationController {
            pop.barButtonItem = navigationItem.rightBarButtonItems?.last
        }
        present(sheet, animated: true)
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
        viewModel.didSelectRow(at: indexPath.row, in: rows)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//
//  SettingsViewController.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsView> {
    private let viewModel: SettingsViewModel
    private var rows: [SettingsViewModel.Row] = []

    init(viewModel: SettingsViewModel) {
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
        viewModel.onToast = { [weak self] msg in
            let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
            self?.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                alert.dismiss(animated: true)
            }
        }
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let row = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSwitchCell.reuseId, for: indexPath) as! SettingsSwitchCell
        cell.fill(title: row.title, isOn: row.isOn)
        cell.onToggle = { [weak self] isOn in
            self?.viewModel.toggle(key: row.key, isOn: isOn)
        }
        return cell
    }
}

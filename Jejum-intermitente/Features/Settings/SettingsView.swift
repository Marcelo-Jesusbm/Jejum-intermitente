//
//  SettingsView.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class SettingsView: UIView, ViewCode {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        addSubview(tableView)
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupViews() {
        tableView.backgroundColor = Colors.background
        tableView.register(SettingsSwitchCell.self, forCellReuseIdentifier: SettingsSwitchCell.reuseId)
        tableView.rowHeight = 56
    }
}

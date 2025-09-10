//
//  HistoryView.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class HistoryView: UIView, ViewCode {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let refresh = UIRefreshControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        addSubview(tableView)
        tableView.addSubview(refresh)
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
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
        tableView.rowHeight = 64
    }
}

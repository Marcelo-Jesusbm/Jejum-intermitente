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
    let headerView = HistoryHeaderView()
    private let emptyView = EmptyStateView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
        accessibilityIdentifier = "history_view"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        addSubview(tableView)
        tableView.addSubview(refresh)
        tableView.tableHeaderView = headerView
        addSubview(emptyView)
        emptyView.isHidden = true
    }

    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupViews() {
        tableView.backgroundColor = Colors.background
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
        tableView.rowHeight = 64
        tableView.accessibilityIdentifier = "history_table"
        layoutHeaderToFit()
    }

    func updateHeader(with summary: MetricsSummary) {
        headerView.fill(with: summary)
        layoutHeaderToFit()
    }

    func setEmpty(_ isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        if isEmpty {
            UIAccessibility.post(notification: .announcement, argument: "Histórico vazio")
        }
    }

    private func layoutHeaderToFit() {
        let targetSize = CGSize(width: bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
        var frame = headerView.frame
        frame.size = CGSize(width: bounds.width, height: height)
        headerView.frame = frame
        tableView.tableHeaderView = headerView
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutHeaderToFit()
    }
}

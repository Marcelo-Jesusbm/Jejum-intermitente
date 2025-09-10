//
//  HistoryCell.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class HistoryCell: UITableViewCell, ViewCode {
    static let reuseId = "HistoryCell"

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trailingLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
        accessoryType = .disclosureIndicator
        selectionStyle = .default
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.axis = .vertical
        vStack.spacing = 2

        contentView.addSubview(vStack)
        contentView.addSubview(trailingLabel)

        vStack.translatesAutoresizingMaskIntoConstraints = false
        trailingLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            vStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            vStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingLabel.leadingAnchor, constant: -8),

            trailingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            trailingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trailingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
    }

    func setupConstraints() {}

    func setupViews() {
        titleLabel.font = Typography.body(17)
        titleLabel.textColor = Colors.textPrimary
        subtitleLabel.font = Typography.caption(12)
        subtitleLabel.textColor = Colors.textSecondary

        trailingLabel.font = Typography.caption(12)
        trailingLabel.textColor = Colors.textSecondary
        trailingLabel.textAlignment = .right
        trailingLabel.numberOfLines = 1
        trailingLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func fill(with row: HistoryViewModel.Row) {
        titleLabel.text = row.title
        subtitleLabel.text = row.subtitle
        trailingLabel.text = row.trailing
        accessoryType = .disclosureIndicator
    }
}

//
//  SettingsOptionCell.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import UIKit

final class SettingsOptionCell: UITableViewCell, ViewCode {
    static let reuseId = "SettingsOptionCell"

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        buildView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func setupConstraints() {}

    func setupViews() {
        titleLabel.font = Typography.body(17)
        titleLabel.textColor = Colors.textPrimary

        valueLabel.font = Typography.caption(12)
        valueLabel.textColor = Colors.textSecondary
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func fill(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}

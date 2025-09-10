//
//  PlansCell.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class PlanCell: UITableViewCell, ViewCode {
    static let reuseId = "PlanCell"

    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
        selectionStyle = .default
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.axis = .vertical
        vStack.spacing = 2

        contentView.addSubview(emojiLabel)
        contentView.addSubview(vStack)

        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 28),

            vStack.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            vStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func setupConstraints() {}

    func setupViews() {
        emojiLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.font = Typography.body(17)
        titleLabel.textColor = Colors.textPrimary
        subtitleLabel.font = Typography.caption(12)
        subtitleLabel.textColor = Colors.textSecondary
    }

    func fill(with row: PlansViewModel.Row) {
        emojiLabel.text = row.emoji
        titleLabel.text = row.title
        subtitleLabel.text = row.subtitle
        accessoryType = row.isSelected ? .checkmark : .none
    }
}

//
//  SettingsSwitchCell.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class SettingsSwitchCell: UITableViewCell, ViewCode {
    static let reuseId = "SettingsSwitchCell"

    private let titleLabel = UILabel()
    let toggle = UISwitch()
    var onToggle: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
        selectionStyle = .none
        toggle.addTarget(self, action: #selector(didToggle), for: .valueChanged)
        isAccessibilityElement = true
        accessibilityTraits.insert(.button)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggle)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func setupConstraints() {}

    func setupViews() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = Colors.textPrimary
    }

    func fill(title: String, isOn: Bool) {
        titleLabel.text = title
        toggle.isOn = isOn

        accessibilityLabel = title
        accessibilityValue = isOn ? "Ativado" : "Desativado"
        accessibilityHint = "Toque duas vezes para alternar"
    }

    @objc private func didToggle() {
        Haptics.lightImpact()
        onToggle?(toggle.isOn)
        UIAccessibility.post(notification: .announcement, argument: "\(titleLabel.text ?? "") \(toggle.isOn ? "ativado" : "desativado")")
    }
}

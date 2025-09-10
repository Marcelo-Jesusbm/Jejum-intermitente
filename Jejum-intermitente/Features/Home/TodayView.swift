//
//  Home.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class TodayView: UIView, ViewCode {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rastreador de Jejum"
        label.font = Typography.titleBold()
        label.textColor = Colors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Inicie/pare seu jejum e acompanhe seu progresso."
        label.font = Typography.body()
        label.textColor = Colors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Iniciar Jejum", for: .normal)
        button.titleLabel?.font = Typography.body(18)
        button.backgroundColor = Colors.primary
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = .init(top: 14, left: 18, bottom: 14, right: 18)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionButton)
    }

    func setupConstraints() {
        [titleLabel, subtitleLabel, actionButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            actionButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }

    func setupViews() {
        isAccessibilityElement = false
        titleLabel.isAccessibilityElement = true
        actionButton.isAccessibilityElement = true
    }

    func update(isFasting: Bool) {
        let title = isFasting ? "Parar Jejum" : "Iniciar Jejum"
        actionButton.setTitle(title, for: .normal)
        actionButton.backgroundColor = isFasting ? Colors.danger : Colors.primary
    }
}

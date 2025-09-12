//
//  EmptyStateView.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 12/09/25.
//

import UIKit

final class EmptyStateView: UIView, ViewCode {
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        isAccessibilityElement = false
        accessibilityTraits = [.staticText]
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        let stack = UIStackView(arrangedSubviews: [emojiLabel, titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }

    func setupConstraints() {}

    func setupViews() {
        emojiLabel.text = "🗒️"
        emojiLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        emojiLabel.adjustsFontForContentSizeCategory = true

        titleLabel.text = "Nada por aqui"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textColor = Colors.textPrimary
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        subtitleLabel.text = "Quando você registrar jejuns, eles aparecerão aqui."
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = Colors.textSecondary
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        isAccessibilityElement = true
        accessibilityLabel = "\(titleLabel.text ?? ""), \(subtitleLabel.text ?? "")"
    }
}

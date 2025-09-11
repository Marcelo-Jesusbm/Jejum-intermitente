//
//  MetricStatView.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import UIKit

final class MetricStatView: UIView, ViewCode {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(valueLabel)
    }

    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setupViews() {
        titleLabel.font = Typography.caption(12)
        titleLabel.textColor = Colors.textSecondary
        titleLabel.textAlignment = .center

        valueLabel.font = Typography.titleBold(20)
        valueLabel.textColor = Colors.textPrimary
        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.7
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    func fill(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
}

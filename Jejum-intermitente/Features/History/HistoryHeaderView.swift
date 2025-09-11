//
//  HistoryHeaderView.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import UIKit

final class HistoryHeaderView: UIView, ViewCode {
    private let titleLabel = UILabel()
    private let statsGrid = UIStackView()
    private let stat1 = MetricStatView()
    private let stat2 = MetricStatView()
    private let stat3 = MetricStatView()
    private let stat4 = MetricStatView()
    private let chartTitle = UILabel()
    private let sparkline = SparklineView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(statsGrid)
        addSubview(chartTitle)
        addSubview(sparkline)
    }

    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        statsGrid.translatesAutoresizingMaskIntoConstraints = false
        chartTitle.translatesAutoresizingMaskIntoConstraints = false
        sparkline.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            statsGrid.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            statsGrid.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            statsGrid.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            statsGrid.heightAnchor.constraint(equalToConstant: 80),

            chartTitle.topAnchor.constraint(equalTo: statsGrid.bottomAnchor, constant: 16),
            chartTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            chartTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            sparkline.topAnchor.constraint(equalTo: chartTitle.bottomAnchor, constant: 8),
            sparkline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sparkline.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            sparkline.heightAnchor.constraint(equalToConstant: 80),
            sparkline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func setupViews() {
        titleLabel.text = Strings.History.header
        titleLabel.font = Typography.titleBold(22)
        titleLabel.textColor = Colors.textPrimary

        statsGrid.axis = .horizontal
        statsGrid.distribution = .fillEqually
        statsGrid.alignment = .fill
        statsGrid.spacing = 8

        let stack1 = wrap(stat1)
        let stack2 = wrap(stat2)
        let stack3 = wrap(stat3)
        let stack4 = wrap(stat4)

        [stack1, stack2, stack3, stack4].forEach { statsGrid.addArrangedSubview($0) }

        chartTitle.text = Strings.History.last14
        chartTitle.font = Typography.body(15)
        chartTitle.textColor = Colors.textSecondary

        sparkline.layer.cornerRadius = 8
        sparkline.clipsToBounds = true
    }

    private func wrap(_ view: UIView) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 10
        container.backgroundColor = Colors.separator.withAlphaComponent(0.1)
        container.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 6),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -6),
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
        ])
        return container
    }

    func fill(with summary: MetricsSummary) {
        let fmt = NumberFormatter()
        fmt.maximumFractionDigits = 1
        fmt.minimumFractionDigits = 0

        let totalH = summary.totalFastingSeconds / 3600.0
        let avgH = summary.averageSeconds / 3600.0
        let bestH = summary.bestSeconds / 3600.0

        stat1.fill(title: "Streak", value: "\(summary.currentStreakDays)d")
        stat2.fill(title: "Média", value: "\(fmt.string(for: avgH) ?? "0") h")
        stat3.fill(title: "Melhor", value: "\(fmt.string(for: bestH) ?? "0") h")
        stat4.fill(title: "Total", value: "\(fmt.string(for: totalH) ?? "0") h")

        sparkline.values = summary.lastDaysDurationsHours
        setNeedsLayout()
        layoutIfNeeded()
    }
}

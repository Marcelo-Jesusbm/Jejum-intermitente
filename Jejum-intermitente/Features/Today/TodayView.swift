//
//  Home.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 10/09/25.
//

import UIKit

final class TodayView: UIView, ViewCode {
    // Cabeçalho
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rastreador de Jejum"
        label.font = Typography.titleBold()
        label.textColor = Colors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let planLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.body()
        l.textColor = Colors.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    private let startLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.caption()
        l.textColor = Colors.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 1
        return l
    }()

    // Progresso
    private let progressView: UIProgressView = {
        let p = UIProgressView(progressViewStyle: .default)
        p.progressTintColor = Colors.accent
        p.trackTintColor = Colors.separator
        p.layer.cornerRadius = 4
        p.clipsToBounds = true
        return p
    }()

    private let elapsedLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.body(16)
        l.textColor = Colors.textPrimary
        return l
    }()

    private let remainingLabel: UILabel = {
        let l = UILabel()
        l.font = Typography.body(16)
        l.textColor = Colors.textPrimary
        l.textAlignment = .right
        return l
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

    private let contentStack = UIStackView()
    private let timesRow = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupHierarchy() {
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill

        timesRow.axis = .horizontal
        timesRow.alignment = .center
        timesRow.distribution = .fillEqually

        timesRow.addArrangedSubview(elapsedLabel)
        timesRow.addArrangedSubview(remainingLabel)

        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(planLabel)
        contentStack.addArrangedSubview(startLabel)
        contentStack.setCustomSpacing(24, after: startLabel)
        contentStack.addArrangedSubview(progressView)
        contentStack.addArrangedSubview(timesRow)
        contentStack.setCustomSpacing(32, after: timesRow)
        contentStack.addArrangedSubview(actionButton)

        addSubview(contentStack)
    }

    func setupConstraints() {
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -24),
            contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),

            progressView.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func setupViews() {
        isAccessibilityElement = false
        [titleLabel, planLabel, startLabel, elapsedLabel, remainingLabel, actionButton].forEach {
            $0.isAccessibilityElement = true
        }
    }

    func update(state: TodayViewModel.UIState) {
        planLabel.text = state.planLine
        startLabel.text = state.startLine
        elapsedLabel.text = state.elapsedText
        remainingLabel.text = state.remainingText
        progressView.setProgress(Float(state.progress), animated: true)

        actionButton.setTitle(state.buttonTitle, for: .normal)
        actionButton.backgroundColor = state.isFasting ? Colors.danger : Colors.primary
    }
}

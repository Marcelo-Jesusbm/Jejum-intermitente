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
        label.text = Strings.Today.title
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = Colors.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let planLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = Colors.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 0
        l.accessibilityTraits.insert(.staticText)
        return l
    }()

    private let startLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .caption1)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = Colors.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 1
        l.accessibilityTraits.insert(.staticText)
        return l
    }()

    // Progresso
    private let progressView: UIProgressView = {
        let p = UIProgressView(progressViewStyle: .default)
        p.progressTintColor = Colors.accent
        p.trackTintColor = Colors.separator
        p.layer.cornerRadius = 4
        p.clipsToBounds = true
        p.isAccessibilityElement = true
        p.accessibilityIdentifier = "today_progress"
        p.accessibilityLabel = "Progresso do jejum"
        return p
    }()

    private let elapsedLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = Colors.textPrimary
        l.accessibilityTraits.insert(.staticText)
        return l
    }()

    private let remainingLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.adjustsFontForContentSizeCategory = true
        l.textColor = Colors.textPrimary
        l.textAlignment = .right
        l.accessibilityTraits.insert(.staticText)
        return l
    }()

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.Today.startBtn, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = Colors.primary
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = .init(top: 14, left: 18, bottom: 14, right: 18)
        button.accessibilityIdentifier = "today_action_button"
        button.accessibilityHint = "Alterna entre iniciar e parar o jejum"
        button.accessibilityTraits.insert(.button)
        return button
    }()

    private let contentStack = UIStackView()
    private let timesRow = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
        accessibilityIdentifier = "today_view"
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
        [planLabel, startLabel, elapsedLabel, remainingLabel, actionButton].forEach {
            $0.isAccessibilityElement = true
        }
    }

    func update(state: TodayViewModel.UIState) {
        planLabel.text = state.planLine
        planLabel.accessibilityLabel = state.planLine

        startLabel.text = state.startLine
        startLabel.accessibilityLabel = state.startLine

        elapsedLabel.text = state.elapsedText
        elapsedLabel.accessibilityLabel = state.elapsedText

        remainingLabel.text = state.remainingText
        remainingLabel.accessibilityLabel = state.remainingText

        progressView.setProgress(Float(state.progress), animated: true)
        let percent = Int((state.progress * 100).rounded())
        progressView.accessibilityValue = "\(percent)% concluído"

        actionButton.setTitle(state.buttonTitle, for: .normal)
        actionButton.backgroundColor = state.isFasting ? Colors.danger : Colors.primary
        actionButton.accessibilityLabel = state.buttonTitle
    }
}

//
//  SessionDetailView.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import UIKit

final class SessionDetailView: UIView, ViewCode {
    let planLabel = UILabel()
    let startLabel = UILabel()
    let endLabel = UILabel()
    let durationLabel = UILabel()

    let endDatePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.datePickerMode = .dateAndTime
        p.preferredDatePickerStyle = .compact
        return p
    }()

    let saveButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(Strings.SessionDetail.save, for: .normal)
        b.titleLabel?.font = Typography.body(18)
        b.backgroundColor = Colors.primary
        b.tintColor = .white
        b.layer.cornerRadius = 10
        b.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
        return b
    }()

    let stopButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(Strings.SessionDetail.stopNow, for: .normal)
        b.titleLabel?.font = Typography.body(18)
        b.backgroundColor = Colors.danger
        b.tintColor = .white
        b.layer.cornerRadius = 10
        b.contentEdgeInsets = .init(top: 12, left: 16, bottom: 12, right: 16)
        return b
    }()

    let deleteButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle(Strings.SessionDetail.delete, for: .normal)
        b.titleLabel?.font = Typography.body(16)
        b.setTitleColor(Colors.danger, for: .normal)
        return b
    }()

    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        backgroundColor = Colors.background
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func setupHierarchy() {
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12

        [planLabel, startLabel, endLabel, durationLabel].forEach {
            $0.font = Typography.body(16)
            $0.textColor = Colors.textPrimary
        }

        let endEditRow = UIStackView(arrangedSubviews: [UILabel(), endDatePicker])
        (endEditRow.arrangedSubviews.first as? UILabel)?.text = Strings.SessionDetail.adjustEnd
        (endEditRow.arrangedSubviews.first as? UILabel)?.font = Typography.body(16)
        (endEditRow.arrangedSubviews.first as? UILabel)?.textColor = Colors.textSecondary
        endEditRow.axis = .horizontal
        endEditRow.distribution = .fill
        endEditRow.alignment = .center
        endEditRow.spacing = 8

        [planLabel, startLabel, endLabel, durationLabel, endEditRow, saveButton, stopButton, deleteButton].forEach {
            stack.addArrangedSubview($0)
        }

        addSubview(stack)
    }

    func setupConstraints() {
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    func setupViews() {
        stopButton.isHidden = true
        saveButton.isHidden = true
        endDatePicker.isHidden = true
    }

    func configure(isActive: Bool, startDate: Date?, endDate: Date?) {
        stopButton.isHidden = !isActive
        let canEditEnd = !isActive && endDate != nil
        saveButton.isHidden = !canEditEnd
        endDatePicker.isHidden = !canEditEnd
        if let endDate = endDate {
            endDatePicker.date = endDate
            endDatePicker.minimumDate = startDate
        }
    }
}

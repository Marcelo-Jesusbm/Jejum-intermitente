//
//  SparklineView.swift
//  Jejum-intermitente
//
//  Created by Marcelo Jesus on 11/09/25.
//

import UIKit

final class SparklineView: UIView {
    var values: [Double] = [] { didSet { setNeedsLayout() } }
    var lineColor: UIColor = Colors.accent
    var fillColor: UIColor = Colors.accent.withAlphaComponent(0.15)
    var lineWidth: CGFloat = 2

    private let lineLayer = CAShapeLayer()
    private let fillLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(fillLayer)
        layer.addSublayer(lineLayer)
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = lineWidth
        fillLayer.fillColor = fillColor.cgColor
        fillLayer.strokeColor = UIColor.clear.cgColor
        isAccessibilityElement = false
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }

    private func redraw() {
        guard values.count > 1 else {
            lineLayer.path = nil
            fillLayer.path = nil
            return
        }
        let rect = bounds.insetBy(dx: 2, dy: 2)
        guard rect.width > 0, rect.height > 0 else { return }

        let maxVal = max(values.max() ?? 0, 0.001)
        let stepX = rect.width / CGFloat(values.count - 1)

        let path = UIBezierPath()
        let fillPath = UIBezierPath()

        for (i, v) in values.enumerated() {
            let x = rect.minX + CGFloat(i) * stepX
            let yRatio = CGFloat(v / maxVal)
            let y = rect.maxY - yRatio * rect.height
            let pt = CGPoint(x: x, y: y)
            if i == 0 {
                path.move(to: pt)
                fillPath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                fillPath.addLine(to: pt)
            } else {
                path.addLine(to: pt)
                fillPath.addLine(to: pt)
            }
        }
        fillPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        fillPath.close()

        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = lineWidth
        lineLayer.path = path.cgPath

        fillLayer.fillColor = fillColor.cgColor
        fillLayer.path = fillPath.cgPath
    }
}

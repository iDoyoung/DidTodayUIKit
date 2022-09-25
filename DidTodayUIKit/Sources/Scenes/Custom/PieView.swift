//
//  PieView.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/14.
//

import UIKit

///  A view that display pie
///
///  You must set start and end angles for draw pie
final class PieView: UIView {
    var color: UIColor = .systemGreen {
        didSet {
            guard let pieLayer = layer.sublayers?.first as? CAShapeLayer else { return }
            pieLayer.strokeColor = color.cgColor
        }
    }
    var start: Double = 0 { didSet { setNeedsDisplay() } }
    var end: Double = 0 { didSet { setNeedsDisplay() } }
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    override func draw(_ rect: CGRect) {
        layer.sublayers?.removeAll()
        /// - Path
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.width) / 2.4
        let startAngle = (start * .pi / 180) - (90 * .pi / 180)
        let endAngle = (end * .pi / 180) - (90 * .pi / 180)
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: radius / 2,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: true)
        /// - Animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        /// -  Shape Layer
        let pieLayer = CAShapeLayer()
        pieLayer.path = path.cgPath
        pieLayer.add(animation, forKey: animation.keyPath)
        pieLayer.fillColor = UIColor.clear.cgColor
        pieLayer.strokeColor = color.cgColor
        pieLayer.lineWidth = radius
        pieLayer.strokeEnd = 1
        layer.addSublayer(pieLayer)
    }
}

//
//  Pie.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/10.
//

import Foundation
import UIKit

class DrawPie: UIView {
    
    var viewModel = MainViewModel()
    
    var start: String
    var end: String
    var colour: UIColor
    
    init(startTime: String, endTime: String, extraY: CGFloat, mainWidth: CGFloat, color: UIColor) {
        start = startTime
        end = endTime
        colour = color
        super.init(frame: CGRect(x: 20, y: 20 + extraY, width: mainWidth - 40, height: mainWidth - 40))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let radius = max(rect.width, rect.width) / 2
        let startTime = start
        let startAngle = CGFloat(viewModel.timeFormat(saved: startTime) * 0.25)
        let finishTime = end
        let endAngle = CGFloat(viewModel.timeFormat(saved: finishTime)*0.25)
        
        let path = UIBezierPath()
        path.addArc(withCenter: center,
                    radius: radius / 2,
                    startAngle: ((startAngle * .pi) / 180) - ((90 * .pi) / 180),
                    endAngle: ((endAngle * .pi) / 180) - ((90 * .pi) / 180),
                    clockwise: true)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.add(animation, forKey: animation.keyPath)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = colour.withAlphaComponent(0.2).cgColor
        
        layer.lineWidth = radius
        layer.strokeEnd = 1
        self.layer.addSublayer(layer)
    }
    
}

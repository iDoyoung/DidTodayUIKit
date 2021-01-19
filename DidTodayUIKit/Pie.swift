//
//  Pie.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/10.
//

import Foundation
import UIKit

class Pie: UIView {
    
    var viewModel = DidViewModel()
    
    override func draw(_ rect: CGRect) {
        
        let dids = viewModel.dids
        let didNow = dids[dids.endIndex - 1]
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let radius = max(rect.width, rect.width) / 2
        
        let startTime = didNow.start
        let startAngle = CGFloat(viewModel.timeFormat(saved: startTime) * 0.25)
        
        let finishTime = didNow.finish
        let endAngle = CGFloat(viewModel.timeFormat(saved: finishTime)*0.25)
        
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center,
                    radius: radius,
                    startAngle: ((startAngle * .pi) / 180) - ((90 * .pi) / 180),
                    endAngle: ((endAngle * .pi) / 180) - ((90 * .pi) / 180),
                    clockwise: true)
        
    
        didNow.colour.withAlphaComponent(0.8).set()
        path.fill()
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.04
        animation.toValue = 1
        animation.duration = 0.25
        
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = didNow.colour.withAlphaComponent(0.5).cgColor
        layer.add(animation, forKey: animation.keyPath)
        self.layer.addSublayer(layer)
        
        let duringAngle = (endAngle) - (startAngle)
        
        let startDegree = (startAngle * .pi) / 180
        let halfDegree = (duringAngle * .pi) / 180

        let pieX = rect.midX + ((radius/2) * sin((halfDegree/2) + startDegree))
        let pieY = rect.midY - ((radius/2) * cos((halfDegree/2) + startDegree))

        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: pieX, y: pieY)
        label.textAlignment = .center
        label.text = didNow.did
        label.textColor = .darkGray
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        let angle = endAngle - (duringAngle/2)
        
        switch angle {
        case 0..<90:
            label.transform = CGAffineTransform(rotationAngle: (-(.pi * (90 - angle)) / 180))
        case 90..<180:
            label.transform = CGAffineTransform(rotationAngle: (.pi * (angle - 90) / 180))
        case 180..<270:
            label.transform = CGAffineTransform(rotationAngle: -(.pi * ((90 - angle) - 180) / 180))
        case 270..<360:
            label.transform = CGAffineTransform(rotationAngle: (.pi * (angle - 270) / 180))
        default:
            label.transform = CGAffineTransform(rotationAngle: 0)
        }

        self.addSubview(label)
    }
    
}

class DrawPie: UIView {
    
    var viewModel = DidViewModel()
    
    
    override func draw(_ rect: CGRect) {
        
        let dids = viewModel.dids
        let didNow = dids[dids.endIndex - 1]
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let radius = max(rect.width, rect.width) / 2
        
        let startTime = didNow.start
        let startAngle = CGFloat(viewModel.timeFormat(saved: startTime) * 0.25)
        
        let finishTime = didNow.finish
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
        layer.strokeColor = didNow.colour.withAlphaComponent(0.2).cgColor
        
        layer.lineWidth = radius
        layer.strokeEnd = 1
        self.layer.addSublayer(layer)
    }
}

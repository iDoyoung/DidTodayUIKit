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
        
        didNow.colour.set()
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

        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.center = CGPoint(x: pieX, y: pieY)
        label.textAlignment = .center
        label.text = didNow.did
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        switch duringAngle {
        case 0..<15 :
            label.font = label.font.withSize(10)
        case 30..<45 :
            label.font = label.font.withSize(16)
        case 45..<360 :
            label.font = label.font.withSize(20)
        
        default:
            label.font = label.font.withSize(12)
        }
        
        if viewModel.colors.contains(didNow.colour) {
            label.textColor = .white
        } else {
            label.textColor = .darkGray
        }
        
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

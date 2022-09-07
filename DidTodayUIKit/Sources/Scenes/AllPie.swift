//
//  Pie.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/22.
//

import Foundation
import UIKit

class AllPie: UIView {
    
    var viewModel = DidViewModel()
    
    override func draw(_ rect: CGRect) {
        
        let dids = viewModel.dids
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = max(rect.width, rect.width) / 2
        
        dids.forEach { (did) in
            let startTime = did.start
            let startAngle = CGFloat(viewModel.timeFormat(saved: startTime) * 0.25)
            let finishTime = did.finish
            let endAngle = CGFloat(viewModel.timeFormat(saved: finishTime)*0.25)
            let path = UIBezierPath()
            path.move(to: center)
            path.addArc(withCenter: center,
                        radius: radius,
                        startAngle: ((startAngle * .pi) / 180) - ((90 * .pi) / 180),
                        endAngle: ((endAngle * .pi) / 180) - ((90 * .pi) / 180),
                        clockwise: true)
            
           
            did.colour.set()
            
            path.fill()
            
            let animation = CABasicAnimation(keyPath: "transform.scale")
                    animation.fromValue = 1.04
                    animation.toValue = 1
                    animation.duration = 0.25
                    
                    let layer = CAShapeLayer()
                    layer.path = path.cgPath
                    layer.fillColor = did.colour.withAlphaComponent(0.5).cgColor
                    layer.add(animation, forKey: animation.keyPath)
                    self.layer.addSublayer(layer)
            
            let duringAngle = (endAngle) - (startAngle)
            
            let startDegree = (startAngle * .pi) / 180
            let halfDegree = (duringAngle * .pi) / 180

            let pieX = rect.midX + ((radius/2) * sin((halfDegree/2) + startDegree))
            let pieY = rect.midY - ((radius/2) * cos((halfDegree/2) + startDegree))

            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 140, height: 20))
            label.center = CGPoint(x: pieX, y: pieY)
            label.textAlignment = .center
            label.text = did.did

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
            
            if viewModel.colours.contains(did.colour) {
                label.textColor = .darkGray
            } else {
                label.textColor = .white
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
            var buttonHeight: CGFloat {
                if duringAngle < 180 {
                    return duringAngle
                } else {
                    return 250
                }
            }
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: buttonHeight))
            button.transform = label.transform
            
            button.addAction(UIAction(handler: { (_) in
                // ???
                print(did.id)
            }), for: .touchUpInside)
            button.center = label.center
            self.addSubview(label)
            self.addSubview(button)
        }
    }
    
}

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
            
           
            did.colour.withAlphaComponent(0.8).set()

            path.fill()
            
            let duringAngle = (endAngle) - (startAngle)
            
            let startDegree = (startAngle * .pi) / 180
            let halfDegree = (duringAngle * .pi) / 180

            let pieX = rect.midX + ((radius/2) * sin((halfDegree/2) + startDegree))
            let pieY = rect.midY - ((radius/2) * cos((halfDegree/2) + startDegree))

            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            label.center = CGPoint(x: pieX, y: pieY)
            label.textAlignment = .center
            label.text = did.did
            label.font = UIFont.preferredFont(forTextStyle: .title3)
            label.textColor = .darkGray
            // endangle (0..90), (90 180), (180 270), (270 360)
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
            //label.transform = CGAffineTransform(rotationAngle: -.pi / (360/endAngle))
            
            self.addSubview(label)
        }
    }
    
}

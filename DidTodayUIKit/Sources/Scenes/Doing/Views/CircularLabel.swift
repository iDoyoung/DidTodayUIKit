//
//  CircularLabel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/08.
//

import UIKit

final class CircularLabel: UIView {

    enum TextAlign {
        case center
        case start
    }
    
    @IBInspectable var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    var textAlign: TextAlign = .center
    @IBInspectable var textSize: CGFloat = 17
    @IBInspectable var isClockwise: Bool = true
    var startAngle: CGFloat {
        switch textAlign {
        case .start:
            return 0
        case .center:
            return 0 - (centralAngle)
        }
    }
    
    @IBInspectable var weight: UIFont.Weight = .regular
    
    lazy var centralAngle: CGFloat = {
        let font = UIFont.systemFont(ofSize: textSize, weight: weight)
        let attributes = [NSAttributedString.Key.font: font]
        let chord = text!.size(withAttributes: attributes).width
        return chord / (bounds.size.width - 20) * .pi * 360 / 20
    }()
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.translateBy(x: self.bounds.midX, y: self.bounds.midX)
        context.scaleBy (x: 1, y: -1)

        centreArcPerpendicular(context: context)
    }
    
    func centreArcPerpendicular(context: CGContext) {
        guard let text else { return }
        let radius = (bounds.size.width) / 2 - 20
        let characters = text.map { $0 }
        let font = UIFont.systemFont(ofSize: textSize, weight: weight)
        let attributes = [NSAttributedString.Key.font: font]
        let direction: CGFloat = isClockwise ? -1 : 1
        let slantCorrection: CGFloat = isClockwise ? -.pi / 2 : .pi / 2
        var theta: CGFloat = -(degreesToRadians(startAngle - 90))
        
        characters.forEach {
            let char = String($0)
            let arc = arc(char.size(withAttributes: attributes).width, radius)
            theta += direction * arc / 2
            centre(text: char, context: context, radius: radius, angle: theta, color: tintColor, font: font, slantAngle: theta + slantCorrection)
            theta += direction * arc / 2
        }
    }
        
    private func arc(_ chord: CGFloat, _ radius: CGFloat) -> CGFloat {
        return 2 * asin(chord / (2 * radius))
    }
    
    private func centre(text string: String, context: CGContext, radius: CGFloat, angle theta: CGFloat, color: UIColor, font: UIFont, slantAngle: CGFloat) {
        let attributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        context.saveGState()
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: radius * cos(theta), y: -(radius * sin(theta)))
        context.rotate(by: -slantAngle)
        let offset = string.size(withAttributes: attributes)
        context.translateBy (x: -offset.width / 2, y: -offset.height / 2)
        string.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
        context.restoreGState()
    }
    
    private func degreesToRadians(_ number: CGFloat) -> CGFloat {
        return (number * .pi / 180)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct CircularLabelPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = CircularLabel()
            view.text = "PreviewOfCircularLabel"
            return view
        }
    }
}
#endif

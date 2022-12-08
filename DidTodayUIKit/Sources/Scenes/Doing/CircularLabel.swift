//
//  CircularLabel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/08.
//

import UIKit

final class CircularLabel: UIView {

    @IBInspectable var text: String?
    @IBInspectable var textSize: CGFloat = 17
    @IBInspectable var isClockwise: Bool = true
    @IBInspectable var startAngle: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.translateBy(x: self.bounds.midX, y: self.bounds.midX)
        context.scaleBy (x: 1, y: -1)

        centreArcPerpendicular(text: text ?? "", context: context, radius: ((self.bounds.size.width - textSize) / 2) - 20, angle: startAngle, color: tintColor, font: UIFont.systemFont(ofSize: textSize, weight: .regular), clockwise: isClockwise)
    }
    
    func centreArcPerpendicular(text str: String, context: CGContext, radius: CGFloat, angle: CGFloat, color: UIColor, font: UIFont, clockwise: Bool){
        let characters = str.map { $0 }
        let length = characters.count
        let attributes = [NSAttributedString.Key.font: font]
        let direction: CGFloat = clockwise ? -1 : 1
        let slantCorrection: CGFloat = clockwise ? -.pi / 2 : .pi / 2
        var theta: CGFloat = -(degreesToRadians(angle - 90))

        for index in 0 ..< length {
            let char = String(characters[index])
            theta += direction * (chordToArc(char.size(withAttributes: attributes).width, radius: radius)) / 2
            centre(text: char, context: context, radius: radius, angle: theta, color: color, font: font, slantAngle: theta + slantCorrection)
            theta += direction * (chordToArc(char.size(withAttributes: attributes).width, radius: radius)) / 2
        }
    }
    
    private func chordToArc(_ chord: CGFloat, radius: CGFloat) -> CGFloat {
        return 2 * asin(chord / (2 * radius))
    }

    private func centre(text string: String, context: CGContext, radius r: CGFloat, angle theta: CGFloat, color: UIColor, font: UIFont, slantAngle: CGFloat) {
        let attributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        context.saveGState()
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: r * cos(theta), y: -(r * sin(theta)))
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

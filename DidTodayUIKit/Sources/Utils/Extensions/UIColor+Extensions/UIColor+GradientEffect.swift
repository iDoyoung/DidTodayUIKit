//
//  UIColor+Gradient.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/28.
//

import UIKit

extension UIColor {
    static func gradientEffect(colors: [UIColor], frame: CGRect, startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
        let layer = CAGradientLayer()
        layer.getGradientLayer(colors: colors,
                               frame: frame,
                               startPoint: startPoint,
                               endPoint: endPoint)
        UIGraphicsBeginImageContext(layer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return .systemBackground
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
}

extension CAGradientLayer {
    fileprivate func getGradientLayer(
        colors: [UIColor],
        frame: CGRect,
        startPoint: CGPoint,
        endPoint: CGPoint) {
            self.frame = frame
            self.colors = colors.map {
                $0.cgColor
            }
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
}

//
//  UIView+animateShake.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/10.
//

import UIKit

extension UIView {
    func animateToShake() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 5, -5, 5, -5, 5, -5, 0 ]
        animation.duration = 0.4
        animation.isAdditive = true
        
        self.layer.add(animation, forKey: "shake")
    }
}

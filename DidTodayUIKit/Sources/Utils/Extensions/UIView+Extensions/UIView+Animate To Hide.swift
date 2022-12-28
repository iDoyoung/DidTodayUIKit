//
//  UIView+Animate To Hide.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/28.
//

import UIKit

extension UIView {

    func hideWithAnimation() {
        if !isHidden {
            UIView.animate(withDuration: 0.35) {
                self.isHidden = true
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    func showWithAnimation() {
        if isHidden {
            UIView.animate(withDuration: 0.35) {
                self.isHidden = false
                self.superview?.layoutIfNeeded()
            }
        }
    }
}

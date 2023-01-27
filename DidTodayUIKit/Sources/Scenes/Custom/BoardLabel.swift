//
//  BoardLabel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/21.
//

import UIKit

@IBDesignable final class BoardLabel: UILabel {
    
    @IBInspectable var texts: [String]?
   
    private var isAnimated: Bool?
    private var flipAnimationQueue = DispatchQueue(label: "filp-animation-queue", qos: .userInteractive)
    ///start animation
    func startAnimation() {
        isAnimated = true
        guard let texts = texts, !texts.isEmpty else { return }
        flipAnimationQueue.async { [weak self] in
            guard let self = self else { return }
            while self.isAnimated! {
                self.texts?.forEach { text in
//                    #if DEBUG
//                    print("Changing Label Text..")
//                    #endif
                    self.animatToLabelChange(to: text)
                    sleep(4)
                }
            }
        }
    }
   
    func stopAnimation() {
        isAnimated = false
    }
    
    private func animatToLabelChange(to text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.flipAnimation()
            self?.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        textAlignment = .center
        numberOfLines = 0
    }
}

private extension UILabel {
    func flipAnimation() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .moveIn
        animation.subtype = .fromTop
        animation.duration = 0.5
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}

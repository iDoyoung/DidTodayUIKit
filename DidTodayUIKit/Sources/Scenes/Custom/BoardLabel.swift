//
//  BoardLabel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/21.
//

import UIKit

@IBDesignable final class BoardLabel: UIView {
    
    @IBInspectable var texts: [String]?
   
    @IBInspectable var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }
    
    @IBInspectable var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private var isAnimated: Bool?
    ///start animation
    func startAnimation() {
        isAnimated = true
        guard let texts = texts, !texts.isEmpty else { return }
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            while self.isAnimated! {
                self.texts?.forEach { text in
                    #if DEBUG
                    print("Changing Label Text..")
                    #endif
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
            self?.label.flipAnimation()
            self?.label.text = text
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
        addSubview(label)
        layer.masksToBounds = true
        setupConstraintsLayout()
    }
    
    private func setupConstraintsLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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

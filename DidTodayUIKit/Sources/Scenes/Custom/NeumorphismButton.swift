//
//  ActionButton.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/22.
//

import UIKit

final class NeumorphismButton: UIControl {
    
    @IBInspectable var text: String? {
        get { buttonView.text }
        set { buttonView.text = newValue }
    }
    private let margin: CGFloat = 10
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    private var longTapAction: (() -> Void)?
    
    private lazy var buttonView: UILabel = {
        let label = UILabel()
        label.borderWidth = 0.5
        label.borderColor = .systemBackground
        label.backgroundColor = .systemBackground
        label.text = "button"
        label.layer.masksToBounds = true
        label.cornerRadius = (frame.height - margin * 2) / 2
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        addSubview(buttonView)
        setupBackgroundView()
        setupControl()
        setupLayoutConstraints()
    }
    
    private func setupBackgroundView() {
        borderWidth = 0.5
        borderColor = .systemBackground
        shadowOpacity = 0.5
        shadowRadius = 2
        shadowColor = .label
        shadowOffset = CGSize(width: 0, height: 1)
        cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
    
    private func setupControl() {
        addTarget(self, action: #selector(prepareFeedbackWithAnimation), for: .touchDown)
        addTarget(self, action: #selector(occurFeedbackWithAnimation), for: .touchUpInside)
        addTarget(self, action: #selector(cancelFeedbackWithAnimation), for: .touchUpOutside)
    }
    
    func setupGestureRecognizer(action: @escaping () -> Void) {
        longTapAction = action
        let gestureRecongnizer = UILongPressGestureRecognizer(target: self, action: #selector(recognizeGesture))
        addGestureRecognizer(gestureRecongnizer)
    }
    
    @objc private func prepareFeedbackWithAnimation(_ sender: UIControl) {
        feedbackGenerator = UIImpactFeedbackGenerator()
        feedbackGenerator?.prepare()
        animateTouchDown()
    }
    
    @objc private func occurFeedbackWithAnimation(_ sender: UIControl) {
        feedbackGenerator?.impactOccurred()
        feedbackGenerator = nil
        animateTouchUp()
    }
    
    @objc private func cancelFeedbackWithAnimation(_ sender: UIControl) {
        feedbackGenerator = nil
        animateTouchUp()
    }
    
    @objc private func recognizeGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            animateTouchUp()
        } else if gesture.state == .began {
            longTapAction?()
        }
    }
    
    private func setupLayoutConstraints() {
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            buttonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin)
        ])
    }
}

//MARK: Animation
extension NeumorphismButton {
    
    func animateTouchDown() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: { [weak self] in
            self?.buttonView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }

    func animateTouchUp() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: { [weak self] in
            self?.buttonView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

//
//  DidCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/13.
//

import UIKit

class DidCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DidCellReuseIdentifier"
    
    let pieView: PieView = {
        let view = PieView()
        return view
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = .monospacedDigitSystemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    func configureVibrancyEffect(to view: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurredEffectView.frame = view.bounds
        vibrancyEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        return vibrancyEffectView
    }
    
    func configure() {
        let vibrancyEffectView = configureVibrancyEffect(to: contentView)
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        pieView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                               size: CGSize(width: contentView.frame.height, height: contentView.frame.height))
        pieView.autoresizingMask = [.flexibleTopMargin,
                                    .flexibleLeftMargin,
                                    .flexibleWidth,
                                    .flexibleHeight]
        vibrancyEffectView.contentView.addSubview(timeLabel)
        addSubview(pieView)
        addSubview(contentLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: pieView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: pieView.trailingAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: pieView.centerYAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: pieView.trailingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
}

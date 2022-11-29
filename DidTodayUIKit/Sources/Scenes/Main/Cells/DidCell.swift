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
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
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
        setupContentView()
        pieView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                               size: CGSize(width: contentView.frame.height, height: contentView.frame.height))
        pieView.autoresizingMask = [.flexibleTopMargin,
                                    .flexibleLeftMargin,
                                    .flexibleWidth,
                                    .flexibleHeight]
        addSubview(pieView)
        addSubview(contentLabel)
        addSubview(timeLabel)
        setupLayoutConstraint()
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .systemBackground
        contentView.cornerRadius = 10
        contentView.shadowOpacity = 0.5
        contentView.shadowRadius = 2
        contentView.shadowColor = .systemGray
        contentView.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    private func setupLayoutConstraint() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: pieView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: pieView.trailingAnchor, constant: 8),
            contentLabel.bottomAnchor.constraint(equalTo: pieView.centerYAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: pieView.trailingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
}

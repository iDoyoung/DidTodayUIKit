//
//  TotalDidCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/23.
//

import UIKit

class TotalDidsCell: UICollectionViewCell {
    static let reuseIdentifier = "total-dids-cell"

    let piesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
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
        let color = UIColor.gradientEffect(colors: [.themeGreen.withAlphaComponent(0.7),
                                                    .themeGreen],
                                           frame: frame,
                                           stratPoint: CGPoint(x: 0.5,
                                                               y: 0),
                                           endPoint: CGPoint(x: 0.5,
                                                             y: 1))
        contentView.backgroundColor = color
        addSubview(piesView)
        addSubview(descriptionLabel)
        setupLayoutConstraint()
    }
    
    //MARK: - Setup
    func setupPiesView(by dids: [MainDidItemsViewModel]) {
        dids.forEach {
            let pieView = PieView()
            pieView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                   size: CGSize(width: piesView.frame.height,
                                                height: piesView.frame.width))
            pieView.autoresizingMask = [.flexibleWidth,
                                        .flexibleHeight]
            pieView.color = $0.color
            pieView.start = $0.startedTimes * 0.25
            pieView.end = $0.finishedTimes * 0.25
            piesView.addSubview(pieView)
        }
    }
    
    private func setupLayoutConstraint() {
        NSLayoutConstraint.activate([
            piesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            piesView.heightAnchor.constraint(equalToConstant: 200),
            piesView.widthAnchor.constraint(equalToConstant: 200),
            piesView.centerYAnchor.constraint(equalTo: centerYAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: piesView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: piesView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: piesView.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
    }
}

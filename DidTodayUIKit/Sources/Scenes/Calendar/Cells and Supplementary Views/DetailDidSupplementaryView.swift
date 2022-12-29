//
//  DetailDidSupplementaryView.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/26.
//

import UIKit

final class DetailDidSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "detail-did-supplementary-view"
    
    let descriptionCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(descriptionCountLabel)
        setupLayoutConstraint()
    }
    
    private func setupLayoutConstraint() {
        descriptionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionCountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionCountLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

//
//  DetailDidSupplementaryView.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/26.
//

import UIKit

final class DetailDidSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "detail-did-supplementary-view"
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pieView, descriptionCountLabel])
        stackView.axis = .horizontal
        return stackView
    }()
    
    let pieView: PieView = {
        let pieView = PieView()
        return pieView
    }()
    
    let descriptionCountLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .systemFont(ofSize: 25, weight: .heavy)
        label.textColor = .customGreen
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
        addSubview(horizontalStackView)
        setupLayoutConstraint()
    }
    
    private func setupLayoutConstraint() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

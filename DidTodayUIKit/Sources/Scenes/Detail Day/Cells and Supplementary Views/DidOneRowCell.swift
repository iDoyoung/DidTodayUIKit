//
//  DidOneRowCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/05.
//

import UIKit

final class DidOneRowCell: UICollectionViewCell {
    
    static let reuseIdentifier = "did-one-row-cell"
    
    //MARK: - UI Objects
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pieView, labelStackView])
        stackView.axis = .horizontal
        return stackView
    }()
   
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, titleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let pieView: PieView = {
        let pieView = PieView()
        return pieView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        let monospacedfont = UIFont.monospacedSystemFont(ofSize: 0, weight: .regular)
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: monospacedfont)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
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
        addSubview(pieView)
        addSubview(titleLabel)
        addSubview(titleLabel)
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

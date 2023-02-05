//
//  TotalDidCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/23.
//

import UIKit

final class TotalDidsCell: UICollectionViewCell {
    
    static let reuseIdentifier = "total-dids-cell"

    private let piesView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [descriptionCountLabel, descriptionTimeLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let descriptionCountLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .customGreen
        return label
    }()
    
    let descriptionTimeLabel: UILabel = {
        let label = UILabel()
        let monoSystemFont = UIFont.monospacedSystemFont(ofSize: 0, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: monoSystemFont)
        label.sizeToFit()
        label.textColor = .customGreen
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backgroundColor = UIColor.gradientEffect(colors: [.customBackground, .secondaryCustomBackground],
                                                 frame: bounds,
                                                 startPoint: CGPoint(x: 0, y: 0),
                                                 endPoint: CGPoint(x: 1, y: 1))
    }
    
    private func configure() {
        setupContentView()
        addSubview(piesView)
        addSubview(verticalStackView)
        setupLayoutConstraint()
    }
    
    //MARK: - Setup
    private func setupContentView() {
        cornerRadius = 20
        ///Set gradient
        borderWidth = 0.5
        borderColor = .separator
        backgroundColor = UIColor.gradientEffect(colors: [.customBackground, .secondaryCustomBackground],
                                                 frame: bounds,
                                                 startPoint: CGPoint(x: 0, y: 0),
                                                 endPoint: CGPoint(x: 1, y: 1))
    }
    
    func setupPiesView(by item: TotalOfDidsItemViewModel) {
        item.totalOfPies.forEach {
            let pieView = PieView()
            pieView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                   size: CGSize(width: piesView.frame.height,
                                                height: piesView.frame.width))
            pieView.autoresizingMask = [.flexibleWidth,
                                        .flexibleHeight]
            pieView.color = $0.color
            pieView.start = $0.startedTime * 0.25
            pieView.end = $0.finishedTime * 0.25
            piesView.addSubview(pieView)
        }
    }
    
    private func setupLayoutConstraint() {
        piesView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            piesView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            piesView.heightAnchor.constraint(equalToConstant: 160),
            piesView.widthAnchor.constraint(equalToConstant: 160),
            piesView.centerYAnchor.constraint(equalTo: centerYAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: piesView.centerYAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: piesView.trailingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -20),
        ])
    }
}

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
        label.font = .systemFont(ofSize: 25, weight: .heavy)
        label.textColor = .customGreen
        return label
    }()
    
    let descriptionTimeLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = .monospacedDigitSystemFont(ofSize: 50, weight: .black)
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
    
    private func configure() {
        addSubview(piesView)
        addSubview(verticalStackView)
        setupLayoutConstraint()
    }
    
    //MARK: - Setup
    func setupPiesView(by item: MainTotalOfDidsItemViewModel) {
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
            piesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            piesView.heightAnchor.constraint(equalToConstant: 200),
            piesView.widthAnchor.constraint(equalToConstant: 200),
            piesView.centerYAnchor.constraint(equalTo: centerYAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: piesView.centerYAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: piesView.trailingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}

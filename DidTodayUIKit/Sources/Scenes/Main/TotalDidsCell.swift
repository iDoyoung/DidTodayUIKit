//
//  TotalDidCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/23.
//

import UIKit

class TotalDidsCell: UICollectionViewCell {
    static let reuseIdentifier = "TotalDidsCell"
    var dids = [MainDidItemsViewModel]() {
        didSet {
            setupPiesView()
            setupDescriptionLabel()
        }
    }
    
    private let piesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .monospacedDigitSystemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let totalDidLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
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
        contentView.backgroundColor = .themeGreen
        addSubview(piesView)
        addSubview(descriptionLabel)
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
    
    //MARK: - Setup
    private func setupPiesView() {
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
    
    private func setupDescriptionLabel() {
        var description: String
        let countOfDids = dids.count
        let totalOfSpentTime = dids
            .map { $0.timesToMinutes }
            .reduce(0) { $0 + $1 }
        let spendTimeToString = String(format: "%02d:%02d", totalOfSpentTime/60, totalOfSpentTime%60)
        description = (countOfDids == 0 ? "Did nothing" : "Did \(dids.count) things,\nTotal \(spendTimeToString)")
        descriptionLabel.text = description
    }
}

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
            setupTotalDidsLabel()
            setupTotalTimesLabel()
        }
    }
    
    private let piesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [totalDidLabel, totalTimeLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        addSubview(piesView)
        addSubview(labelStackView)
        NSLayoutConstraint.activate([
            piesView.leadingAnchor.constraint(equalTo: leadingAnchor),
            piesView.heightAnchor.constraint(equalToConstant: 200),
            piesView.widthAnchor.constraint(equalToConstant: 200),
            piesView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.topAnchor.constraint(equalTo: piesView.topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: piesView.trailingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            labelStackView.bottomAnchor.constraint(equalTo: piesView.bottomAnchor)
        ])
    }
    
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
    private func setupTotalDidsLabel() {
        totalDidLabel.text = "Did \(dids.count) things"
    }
    private func setupTotalTimesLabel() {
        let sum = dids
            .map { $0.timesToMinutes }
            .reduce(0) { $0 + $1 }
        let spendTime = String(format: "%02d:%02d", sum/60, sum%60)
        totalTimeLabel.text = "Total \(spendTime)."
    }
}

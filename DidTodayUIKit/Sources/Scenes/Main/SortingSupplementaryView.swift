//
//  SortingSupplementaryView.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/16.
//

import UIKit

final class SortingSupplementaryView: UICollectionReusableView {
    
    static let reuseIdentifier = "sorting-supplementary-view"
    
    let recentlyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Recently", for: .normal)
        button.tintColor = .label
        button.isSelected = true
        return button
    }()
    
    let muchTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Much time", for: .normal)
        button.tintColor = .label
        return button
    }()
    
    //TODO: Configure reverse switch
    let switchButton: UISwitch = {
        let switchButton = UISwitch()
        return switchButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(recentlyButton)
        addSubview(muchTimeButton)
        setupLayoutConstraint()
    }
    
    private func setupLayoutConstraint() {
        recentlyButton.translatesAutoresizingMaskIntoConstraints = false
        muchTimeButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentlyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            recentlyButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            muchTimeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            muchTimeButton.leadingAnchor.constraint(equalTo: recentlyButton.trailingAnchor, constant: 10)
//            muchTimeButton.trailingAnchor.constraint(greaterThanOrEqualTo: switchButton.layoutMarginsGuide.leadingAnchor),
//            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            switchButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
}

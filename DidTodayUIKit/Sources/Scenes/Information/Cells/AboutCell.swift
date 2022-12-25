//
//  CustomListCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/23.
//

import UIKit

final class AboutCell: UITableViewCell {
   
    static let reuseIdentifier = "about-cell"
    
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let versionLabel = UILabel()
    
    func update(to about: AboutDid) {
        logoImageView.image = about.image
        titleLabel.text = about.title
        versionLabel.text = about.version
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(versionLabel)
        setupLayoutConstraint()
    }
    
    private func setupLayoutConstraint() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                               constant: 20),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                 constant: -20),
            versionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
}


//
//  DidTitleCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/04.
//

import UIKit

final class DidTitleCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: bounds)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private func configureUI() {
        cornerRadius = 10
        addSubview(titleLabel)
        titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
}

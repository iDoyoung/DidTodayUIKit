//
//  DidTitleCell.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/04.
//

import UIKit

class DidTitleCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        return label
    }()
}

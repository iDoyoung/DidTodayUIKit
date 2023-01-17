//
//  MoreAboutLink.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/24.
//

import Foundation

struct AboutItem {
    let title: String
    let selecting: (() -> Void)?
    
    init(title: String, action: (() -> Void)? = nil) {
        self.title = title
        selecting = action
    }
}

//
//  MoreAboutLink.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/24.
//

import Foundation

struct AboutItem {
    let title: String
    let route: (() -> Void)?
    
    init(title: String, route: (() -> Void)? = nil) {
        self.title = title
        self.route = route
    }
}

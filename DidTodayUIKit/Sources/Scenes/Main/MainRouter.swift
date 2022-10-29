//
//  MainSegue.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/27.
//

import Foundation

struct MainRouter {
    let showCalendar: ([MainDidItemsViewModel]) -> Void
    let showCreateDid: () -> Void
}

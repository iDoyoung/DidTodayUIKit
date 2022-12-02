//
//  MainSegue.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/27.
//

import Foundation

struct MainRouter {
    let showCalendar: ([Did]) -> Void
    let showCreateDid: () -> Void
    let showDoing: () -> Void
}

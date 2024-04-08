//
//  MainSegue.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/27.
//

import Foundation

struct TodayRouter {
    let showCalendar: () -> Void
    let showCreateDid: (Date?, Date?) -> Void
    let showDoing: () -> Void
    let showInformation: () -> Void
    let showDidDetails: (Did) -> Void
}

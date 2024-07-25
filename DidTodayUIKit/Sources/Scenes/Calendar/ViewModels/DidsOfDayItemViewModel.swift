//
//  DidsOfDayViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/08.
//

import UIKit

struct DidsOfDayItemViewModel: Hashable {
    let started: Double
    let ended: Double
    let title: String
    let color: UIColor
    
    init(_ did: Did) {
        started = Double(Date.getHours(did.started) + Date.getMinutes(did.started))
        ended = Double(Date.getHours(did.finished) + Date.getMinutes(did.finished))
        title = did.content
        color = did.uiColor
    }
}

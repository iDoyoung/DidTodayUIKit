//
//  MainDidsItemViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/16.
//

import UIKit

struct DidItemViewModel: Hashable {
    let startedTimes: Double
    let finishedTimes: Double
    let times: String
    let timesToMinutes: Int
    let content: String
    let color: UIColor
    
    init(_ did: Did) {
        startedTimes = Double(Date.getHours(did.started) + Date.getMinutes(did.started))
        finishedTimes = Double(Date.getHours(did.finished) + Date.getMinutes(did.finished))
        times = Date.differenceToString(from: did.started, to: did.finished)
        timesToMinutes = Date.differenceToMinutes(from: did.started, to: did.finished)
        content = did.content
        color = UIColor(red: CGFloat(did.pieColor.red),
                        green: CGFloat(did.pieColor.green),
                        blue: CGFloat(did.pieColor.blue),
                        alpha: CGFloat(did.pieColor.alpha))
    }
}

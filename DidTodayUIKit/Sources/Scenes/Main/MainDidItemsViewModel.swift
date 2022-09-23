//
//  MainDidsItemViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/16.
//

import UIKit

struct MainDidItemsViewModel: Hashable {
    let startedTimes: Double
    let finishedTimes: Double
    let times: String
    let content: String
    let color: UIColor
    
    init(_ did: Did) {
        startedTimes = Double(getHours(did.started) + getMinutes(did.started))
        finishedTimes = Double(getHours(did.finished) + getMinutes(did.finished))
        times = Date.diffetcneceToString(from: did.started, to: did.finished)
        content = did.content
        color = UIColor(red: CGFloat(did.pieColor.red),
                        green: CGFloat(did.pieColor.green),
                        blue: CGFloat(did.pieColor.blue),
                        alpha: CGFloat(did.pieColor.alpha))
    }
}

private func getHours(_ date: Date) -> Int {
    let hours = Calendar.current.component(.hour, from: date) * 60
    return hours
}
private func getMinutes(_ date: Date) -> Int {
    let minutes = Calendar.current.component(.minute, from: date)
    return minutes
}

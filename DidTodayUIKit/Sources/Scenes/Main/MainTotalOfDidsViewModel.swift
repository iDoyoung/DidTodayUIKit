//
//  MainTotalOfDidsViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/17.
//

import UIKit

struct MainTotalOfDidsItemViewModel: Hashable {
    let description: String
    let totalOfPies: [MainPieViewModel]
    
    init(_ dids: [Did]) {
        let countOfDids = dids.count
        let totalOfSpentTime = dids
            .map { Date.differenceToMinutes(from: $0.started, to: $0.finished) }
            .reduce(0) { $0 + $1 }
        let spendTimeToString = String(format: "%02d:%02d", totalOfSpentTime/60, totalOfSpentTime%60)
        description = (countOfDids == 0 ? "Did nothing" : "Did \(dids.count) things,\nTotal \(spendTimeToString)")
        totalOfPies = dids.map { MainPieViewModel($0) }
    }
}

struct MainPieViewModel: Hashable {
    let color: UIColor
    let startedTime: Double
    let finishedTime: Double
    
    init(_ did: Did) {
        startedTime = Double(Date.getHours(did.started) + Date.getMinutes(did.started))
        finishedTime = Double(Date.getHours(did.finished) + Date.getMinutes(did.finished))
        color = UIColor(red: CGFloat(did.pieColor.red),
                        green: CGFloat(did.pieColor.green),
                        blue: CGFloat(did.pieColor.blue),
                        alpha: CGFloat(did.pieColor.alpha))
    }
}

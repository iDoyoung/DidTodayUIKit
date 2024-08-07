//
//  MainTotalOfDidsViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/17.
//

import UIKit

struct TotalOfDidsItemViewModel: Hashable {
    let descriptionCount: String
    let descriptionTime: String
    let totalOfPies: [TotalOfDidsPieViewModel]
    
    init(_ dids: [Did]) {
        let totalOfSpentTime = dids
            .map { Date.differenceToMinutes(from: $0.started, to: $0.finished) }
            .reduce(0) { $0 + $1 }
        let spendTimeToString = String(format: "%02d:%02d", totalOfSpentTime/60, totalOfSpentTime%60)
        descriptionCount = CustomText.didThing(count: dids.count)
        descriptionTime = "\(spendTimeToString)"
        totalOfPies = dids.map { TotalOfDidsPieViewModel($0) }
    }
}

struct TotalOfDidsPieViewModel: Hashable {
    let color: UIColor
    let startedTime: Double
    let finishedTime: Double
    
    init(_ did: Did) {
        startedTime = Double(Date.getHours(did.started) + Date.getMinutes(did.started))
        finishedTime = Double(Date.getHours(did.finished) + Date.getMinutes(did.finished))
        color = did.uiColor
    }
}

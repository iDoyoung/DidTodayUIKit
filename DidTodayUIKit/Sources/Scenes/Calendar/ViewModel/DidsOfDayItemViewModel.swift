//
//  DidsOfDayViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/08.
//

import UIKit

struct DidsOfDayItemViewModel: Hashable {
    let title: String
    let color: UIColor
    
    init(_ did: Did) {
        title = did.content
        color = UIColor(
            red: CGFloat(did.pieColor.red),
            green: CGFloat(did.pieColor.green),
            blue: CGFloat(did.pieColor.blue),
            alpha: CGFloat(did.pieColor.alpha))
    }
}

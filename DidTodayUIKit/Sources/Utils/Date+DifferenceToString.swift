//
//  Date+DifferenceToString.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/23.
//

import Foundation

extension Date {
    static func diffetcneceToString(from start: Date, to end: Date) -> String {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        let hours = difference.hour
        let minutes = difference.minute
        return String(format: "%02d:%02d", hours ?? 0, minutes ?? 0)
    }
}

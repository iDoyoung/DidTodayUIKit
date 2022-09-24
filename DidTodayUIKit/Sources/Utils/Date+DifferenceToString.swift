//
//  Date+DifferenceToString.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/23.
//

import Foundation

extension Date {
    static func differeneceToString(from start: Date, to end: Date) -> String {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        let hours = difference.hour
        let minutes = difference.minute
        return String(format: "%02d:%02d", hours ?? 0, minutes ?? 0)
    }
    static func differenceToMinutes(from start: Date, to end: Date) -> Int {
        let difference = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        let hours = difference.hour ?? 0
        let minutes = difference.minute ?? 0
        return hours * 60 + minutes
    }
}

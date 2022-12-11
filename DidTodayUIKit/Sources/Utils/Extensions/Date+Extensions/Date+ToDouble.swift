//
//  Date+ToDouble.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/19.
//

import Foundation

extension Date {
    func timesCalculateToMinutes() -> Int {
        let hours = formatToHours(date: self)
        let minutes = formatToMinutes(date: self)
        return hours * 60 + minutes
    }
}

private let dateFormatter = DateFormatter()

private func formatToHours(date: Date) -> Int {
    dateFormatter.dateFormat = "HH:mm"
    return Calendar.current.component(.hour, from: date)
}

private func formatToMinutes(date: Date) -> Int {
    dateFormatter.dateFormat = "HH:mm"
    return Calendar.current.component(.minute, from: date)
}

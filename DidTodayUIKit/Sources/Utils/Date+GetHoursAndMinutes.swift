//
//  Date+GetHoursAndMinutes.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/23.
//

import Foundation

extension Date {
    static func getHours(_ date: Date) -> Int {
        let hours = Calendar.current.component(.hour, from: date) * 60
        return hours
    }
    static func getMinutes(_ date: Date) -> Int {
        let minutes = Calendar.current.component(.minute, from: date)
        return minutes
    }
}

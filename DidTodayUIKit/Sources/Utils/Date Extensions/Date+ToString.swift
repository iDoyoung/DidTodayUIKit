//
//  Date+ToString.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/30.
//

import Foundation

extension Date {
    static func todayDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: Date())
    }
}

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
    
    func currentTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

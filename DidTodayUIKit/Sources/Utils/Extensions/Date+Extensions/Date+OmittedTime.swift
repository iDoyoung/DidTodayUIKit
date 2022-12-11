//
//  Date+OmittedTime.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/31.
//

import Foundation

extension Date {
    func omittedTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: components)!
    }
}

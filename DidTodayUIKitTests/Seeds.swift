//
//  Seeds.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/09.
//

import XCTest
@testable import DidTodayUIKit

struct Seeds {
   
    struct Dids {
        
        private static var calendar = Calendar.current
        private static var midnight = calendar.startOfDay(for: Date())
        
        static let newYearParty = Did(id: UUID(),
                                      started: calendar.date(from: DateComponents(year: 2022, month: 01, day: 01))!,
                                      finished: calendar.date(from: DateComponents(year: 2022, month: 01, day: 01))!,
                                      content: "New Year Party",
                                      red: 0,
                                      green: 0,
                                      blue: 0,
                                      alpha: 0)
        static let christmasParty = Did(id: UUID(),
                                        started: calendar.date(from: DateComponents(year: 2021, month: 12, day: 25))!,
                                        finished: calendar.date(from: DateComponents(year: 2021, month: 12, day: 25))!,
                                        content: "Christmas Party",
                                        red: 0,
                                        green: 0,
                                        blue: 0,
                                        alpha: 0)
        static let todayDidMock = Did(id: UUID(),
                                         started: midnight,
                                         finished: midnight,
                                         content: "Start Today",
                                         red: 0,
                                         green: 0,
                                         blue: 0,
                                         alpha: 0)
        static let todayDidMock2 = Did(id: UUID(),
                                       started: calendar.date(byAdding: DateComponents(hour: 1), to: midnight)!,
                                       finished: Date(),
                                         content: "Did Something",
                                         red: 0,
                                         green: 0,
                                         blue: 0,
                                         alpha: 0)
    }
    
    struct MockDate {
        static let midnight = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        static let noon = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
    }
}

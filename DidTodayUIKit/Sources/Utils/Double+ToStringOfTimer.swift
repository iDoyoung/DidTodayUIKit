//
//  Double+ToStringOfTimer.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/05.
//

import Foundation

extension Double {
    func toTimeWithHoursMinutes() -> String {
        let hours = Int(self)/3600
        let minutes = Int(self)%3600/60
        
        return String(format: "%02d:%02d", hours, minutes)
    }
}

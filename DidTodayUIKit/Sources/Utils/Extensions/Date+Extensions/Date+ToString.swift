//
//  Date+ToString.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/30.
//

import Foundation

extension Date {
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: self)
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        let currentLanguage = Locale.current.languageCode
        if currentLanguage == "ko" {
            dateFormatter.dateFormat = "yyyy년 MMM d일"
        } else if currentLanguage == "en" {
            dateFormatter.dateFormat = "MMM d, yyyy"
        } else {
            //Tag: - for setting more language
            dateFormatter.dateFormat = "yyyy.MMM.d"
        }
        return dateFormatter.string(from: self)
    }
    
    func currentTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}

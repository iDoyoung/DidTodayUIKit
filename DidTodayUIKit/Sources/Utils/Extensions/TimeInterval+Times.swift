//
//  TimeInterval+Times.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/30.
//

import Foundation

extension TimeInterval {
    
    var timeToString: String {
        String(format:"%d:%02d:%02d", hour, minute, second)
    }
    
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    
    var millisecond: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}

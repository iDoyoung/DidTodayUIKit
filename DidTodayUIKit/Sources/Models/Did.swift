//
//  DidItem.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/08.
//

import Foundation

struct Did: Equatable, Hashable {
    let id: UUID
    let withTimer: Bool
    let started: Date
    let finished: Date
    var content: String
    var pieColor: PieColor
    
    static func == (lhs: Did, rhs: Did) -> Bool {
        lhs.id == rhs.id
    }
    
    init(withTimer: Bool = false, started: Date, finished: Date, content: String, color: PieColor) {
        self.id = UUID()
        self.withTimer = withTimer
        self.started = started
        self.finished = finished
        self.content = content
        self.pieColor = color
    }
    init(id: UUID, withTimer: Bool = false, started: Date, finished: Date, content: String, red: Float, green: Float, blue: Float, alpha: Float) {
        self.id = id
        self.withTimer = withTimer
        self.started = started
        self.finished = finished
        self.content = content
        self.pieColor = PieColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    struct PieColor: Hashable {
        let red: Float
        let green: Float
        let blue: Float
        let alpha: Float
    }
}

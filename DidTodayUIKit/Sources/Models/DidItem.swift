//
//  DidItem.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/08.
//

import Foundation

struct DidItem: Equatable {
    let id: UUID
    let started: Date
    let finished: Date
    var content: String
    var pieColor: PieColor
    
    static func == (lhs: DidItem, rhs: DidItem) -> Bool {
        lhs.id == rhs.id
    }
    
    init(started: Date, finished: Date, content: String, color: PieColor) {
        self.id = UUID()
        self.started = started
        self.finished = finished
        self.content = content
        self.pieColor = color
    }
    init(id: UUID, started: Date, finished: Date, content: String, red: Float, green: Float, blue: Float, alpha: Float) {
        self.id = id
        self.started = started
        self.finished = finished
        self.content = content
        self.pieColor = PieColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    struct PieColor {
        let red: Float
        let green: Float
        let blue: Float
        let alpha: Float
    }
}

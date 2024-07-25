//
//  DidItem.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/08.
//

import Foundation
import SwiftUI

@Observable
final class Did: Identifiable, Equatable {
    
    let id: UUID
    let withTimer: Bool
    var started: Date
    var finished: Date
    var content: String
//    var pieColor: PieColor
    
    //FIXME: - UI 요소를 모델 레이어에서 설정하는게 맞을까?
    var uiColor: UIColor 
//    {
//        UIColor(
//            red: CGFloat(pieColor.red),
//            green: CGFloat(pieColor.green),
//            blue: CGFloat(pieColor.blue),
//            alpha: CGFloat(pieColor.alpha)
//        )
//    }
    
    var color: Color {
        Color(uiColor: uiColor)
    }
    
    static func == (lhs: Did, rhs: Did) -> Bool {
        lhs.id == rhs.id
    }
    
    init(withTimer: Bool = false, started: Date, finished: Date, content: String, color: UIColor) {
        self.id = UUID()
        self.withTimer = withTimer
        self.started = started
        self.finished = finished
        self.content = content
        self.uiColor = color
    }
    
    init(id: UUID, withTimer: Bool = false, started: Date, finished: Date, content: String, red: Float, green: Float, blue: Float, alpha: Float) {
        self.id = id
        self.withTimer = withTimer
        self.started = started
        self.finished = finished
        self.content = content
        self.uiColor = UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
//        self.pieColor = PieColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

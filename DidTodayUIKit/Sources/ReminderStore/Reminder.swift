//
//  Reminder.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 3/11/24.
//

import Foundation
import UIKit

struct Reminder: Equatable, Identifiable {
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
    var themeColor: CGColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
}

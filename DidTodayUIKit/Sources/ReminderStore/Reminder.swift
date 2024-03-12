//
//  Reminder.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 3/11/24.
//

import Foundation

struct Reminder: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var dueDate: Date
    var notes: String? = nil
    var isComplete: Bool = false
}

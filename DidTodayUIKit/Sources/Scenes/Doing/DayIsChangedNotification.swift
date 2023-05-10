//
//  DayIsChangedNotificationRequestable.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/04.
//

import Foundation
import UserNotifications

protocol DayIsChangedNotification: UserNotificationRequestable { }

extension DayIsChangedNotification {
    
    func setTrigger() -> UNNotificationTrigger {
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) else {
            fatalError("there is no tomorrow")
        }
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: tomorrow)
        return UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    }
    
    func setContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = CustomText.dayIsChangedNotificationTitle
        content.subtitle = CustomText.dayIsChangedNotificationSubTitle
        content.sound = UNNotificationSound.default
        return content
    }
}

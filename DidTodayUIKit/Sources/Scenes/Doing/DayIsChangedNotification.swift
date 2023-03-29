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
        UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
    }
    
    func setContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = CustomText.dayIsChangedNotificationTitle
        content.subtitle = CustomText.dayIsChangedNotificationSubTitle
        content.sound = UNNotificationSound.default
        return content
    }
}

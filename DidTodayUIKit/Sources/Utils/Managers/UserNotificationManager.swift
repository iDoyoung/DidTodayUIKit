//
//  UserNotificationManager.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/04.
//

import Foundation
import UserNotifications

protocol UserNotificationRequestable {
    func setTrigger() -> UNNotificationTrigger
    func setContent() -> UNMutableNotificationContent
}

extension UserNotificationRequestable {
    
    func requestUserNotification(with identifier: String = UUID().uuidString) {
       let request = UNNotificationRequest(identifier: identifier,
                                           content: setContent(),
                                           trigger: setTrigger())
        UNUserNotificationCenter.current().add(request)
    }
}

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
    
    func setTrigger() -> UNNotificationTrigger? {
        return nil
    }
    
    func setContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "하루가 지났습니다."
        content.subtitle = "어떤 행동을 시작하고 아직 진행중인 상태입니다."
        content.sound = UNNotificationSound.default
        return content
    }
}

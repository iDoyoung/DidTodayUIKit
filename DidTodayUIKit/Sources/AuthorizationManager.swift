//
//  AuthorizationManager.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/04.
//

import Foundation
import UserNotifications

enum AuthorizationStatus {
    case notDetermined, restricted, denied, authorized, notSupported
}

final class AuthorizationManager {
   
    static func requestUserNotificationsAuthorization(completion: @escaping (Result<AuthorizationStatus, Error>) -> Void) {
        var authorizationOptions: UNAuthorizationOptions
        
        if #available(iOS 15, watchOS 8.0, macOS 12, *) {
            authorizationOptions = [.badge, .sound, .alert, .timeSensitive]
        } else {
            authorizationOptions = [.badge, .sound, .alert]
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { granted, error in
            if let error = error {
                completion(.failure(error))
            } else if !granted {
                completion(.success(.denied))
            } else {
                UNUserNotificationCenter.current().getNotificationSettings { notificationSettings in
                    switch notificationSettings.authorizationStatus {
                        case .notDetermined:
                            completion(.success(.notDetermined))
                        case .denied:
                            completion(.success(.denied))
                        case .authorized:
                            completion(.success(.authorized))
                        default:
                            completion(.success(.notSupported))
                    }
                }
            }
        }
    }
}

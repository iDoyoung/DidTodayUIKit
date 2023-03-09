//
//  TimerAlert.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/05.
//

import UIKit

protocol TimerAlert {
    func cancelTimer()
//    func doneTimer()
}

extension TimerAlert {
    
    func cancelTimerAlert() -> UIAlertController {
        let alert = UIAlertController(title: CustomText.cancelTimerTitle, message: CustomText.cancelTimerMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: CustomText.cancel, style: .cancel)
        let allowAction = UIAlertAction(title: CustomText.okay, style: .default) { _ in
            cancelTimer()
        }
        alert.addAction(cancelAction)
        alert.addAction(allowAction)
        return alert
    }
//    func doneTimerAlert() -> UIAlertController {
//        let alert = UIAlertController(title: CustomText.doneTimerTitle, message: CustomText.doneTimerMessage, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: CustomText.cancel, style: .cancel)
//        let allowAction = UIAlertAction(title: CustomText.okay, style: .default) { _ in
//            doneTimer()
//        }
//        alert.addAction(cancelAction)
//        alert.addAction(allowAction)
//        return alert
//    }
}

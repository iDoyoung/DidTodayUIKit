//
//  TimerAlert.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/05.
//

import UIKit

protocol TimerAlert {
    func cancelTimer()
    func doneTimer()
}

extension TimerAlert {
    
    func cancelTimerAlert() -> UIAlertController {
        let alert = UIAlertController(title: "취소하겠습니까?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let allowAction = UIAlertAction(title: "OK", style: .default) { _ in
            cancelTimer()
        }
        alert.addAction(cancelAction)
        alert.addAction(allowAction)
        return alert
    }
    
    func doneTimerAlert() -> UIAlertController {
        let alert = UIAlertController(title: "일을 끝냈습니까?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let allowAction = UIAlertAction(title: "OK", style: .default) { _ in
            doneTimer()
        }
        alert.addAction(cancelAction)
        alert.addAction(allowAction)
        return alert
    }
}

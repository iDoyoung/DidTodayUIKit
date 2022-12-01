//
//  TimerManager.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/01.
//

import Foundation

final class TimerManager {
    
    var timer: DispatchSourceTimer?
    
    func configureTimer(event: @escaping() -> Void)  {
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: 1)
        timer.setEventHandler(handler: event)
        self.timer = timer
    }
    
}

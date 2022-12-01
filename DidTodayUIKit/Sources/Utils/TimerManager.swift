//
//  TimerManager.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/01.
//

import Foundation

final class TimerManager {
    
    var timer: DispatchSourceTimer?
    var count: Double = 0
    
    func configureTimer()  {
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: 1)
        timer.setEventHandler(handler: countTime)
        self.timer = timer
    }
    
    func startTimer() {
        timer?.resume()
    }
    
    func stopTimer() {
        timer?.suspend()
    }
    
    private func countTime() {
        count += 1
    }
}

//
//  TimerManager.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/01.
//

import Foundation

protocol TimerManagerProtocol {
    func configureTimer(handler: @escaping () -> Void)
    func startTimer()
    func stopTimer()
}

final class TimerManager: TimerManagerProtocol {
    
    var timer: DispatchSourceTimer?
    
    func configureTimer(handler: @escaping () -> Void) {
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: 1)
        timer.setEventHandler(handler: handler)
        self.timer = timer
    }
    
    func startTimer() {
        timer?.resume()
        #if DEBUG
        print("Start Timer at \(Date())")
        #endif
    }
    
    func stopTimer() {
        #if DEBUG
        print("Stop Timer at \(Date())")
        #endif
        timer?.suspend()
    }
    
    deinit {
        timer?.resume()
        timer?.cancel()
        timer = nil
    }
}

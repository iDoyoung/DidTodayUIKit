//
//  DoingViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/01.
//

import Foundation
import Combine

protocol DoingViewModelProtocol: DoingViewModelInput, DoingViewModelOutput {   }

protocol DoingViewModelInput {
    func startDoing()
    func stopDoing()
}

protocol DoingViewModelOutput {
}

final class DoingViewModel: DoingViewModelProtocol {
    
    private var timerManager: TimerManagerProtocol?
    
    //MARK: Input
    func startDoing() {
        timerManager?.startTimer()
    }
    
    func stopDoing() {
        timerManager?.stopTimer()
    }
    
    func endDoing() {
        timerManager?.stopTimer()
    }
    
    init(timerManager: TimerManagerProtocol) {
        self.timerManager = timerManager
        timerManager.configureTimer()
    }
}

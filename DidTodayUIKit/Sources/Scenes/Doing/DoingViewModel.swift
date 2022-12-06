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
    var timesOfTimer: CurrentValueSubject<String, Never> { get }
    var doneIsEnabled: CurrentValueSubject<Bool, Never> { get }
}

final class DoingViewModel: DoingViewModelProtocol {
    
    private var timerManager: TimerManagerProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    
    init(timerManager: TimerManagerProtocol) {
        self.timerManager = timerManager
        timerManager.configureTimer(handler: countSeconds)
        count
            .sink { [weak self] time in
                if time > 60 {
                    self?.doneIsEnabled.send(true)
                }
                self?.timesOfTimer.send(time.toTimeWithHoursMinutes())
            }
            .store(in: &cancellableBag)
    }

    private func countSeconds() {
        count.value += 1
    }
    
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
    
    //MARK: Output
    var timesOfTimer = CurrentValueSubject<String, Never>("00:00")
    var doneIsEnabled =  CurrentValueSubject<Bool, Never>(false)
}

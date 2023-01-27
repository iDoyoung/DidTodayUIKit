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
    var startedTime: PassthroughSubject<String, Never> { get }
    var timesOfTimer: CurrentValueSubject<String, Never> { get }
    var titleIsEmpty: CurrentValueSubject<Bool, Never> { get }
    var isLessThanTime: CurrentValueSubject<Bool, Never> { get }
    
    func showCreateDid()
}

final class DoingViewModel: DoingViewModelProtocol {
    
    private var timerManager: TimerManagerProtocol?
    private var router: DoingRouter?
    private var cancellableBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    
    init(timerManager: TimerManagerProtocol, router: DoingRouter) {
        self.timerManager = timerManager
        self.router = router
        timerManager.configureTimer(handler: countSeconds)
        ///Observe Count Time
        count
            .sink { [weak self] time in
                //TODO: Set time of minimum condition
                if time == (60*5) {
                    self?.isLessThanTime.send(false)
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
        startedDate = Date()
        timerManager?.startTimer()
    }
    
    func stopDoing() {
        timerManager?.stopTimer()
    }
    
    func endDoing() {
        timerManager?.stopTimer()
        endedDate = Date()
    }
    
    //MARK: Output
    ///It is output?. didSet is bad choice?
    var startedDate: Date? {
        didSet {
            let text = CustomText.started(time: startedDate?.currentTimeToString() ?? "00:00")
            startedTime.send(text)
        }
    }
    var endedDate: Date?
    
    var startedTime = PassthroughSubject<String, Never>()
    var timesOfTimer = CurrentValueSubject<String, Never>("00:00")
    var titleIsEmpty =  CurrentValueSubject<Bool, Never>(true)
    var isLessThanTime = CurrentValueSubject<Bool, Never>(true)

    func showCreateDid() {
        endDoing()
        if startedDate != nil, endedDate != nil {
            router?.showCreateDid(startedDate, endedDate)
        }
    }
}

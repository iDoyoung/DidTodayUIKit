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
    func endDoing()
}

protocol DoingViewModelOutput {
    var startedTime: PassthroughSubject<String?, Never> { get }
    var timesOfTimer: CurrentValueSubject<String?, Never> { get }
    var isLessThanTime: CurrentValueSubject<Bool, Never> { get }
    
    func showCreateDid()
    func cancel()
}

final class DoingViewModel: DoingViewModelProtocol {
    
    private var router: DoingRouter?
    private var cancellableBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    
    init(router: DoingRouter) {
        self.router = router
        ///Observe Count Time
        count
            .sink { [weak self] time in
                //TODO: Set time of minimum condition
                if self?.isLessThanTime.value == true, time >= (60*5) {
                    self?.isLessThanTime.send(false)
                }
                self?.timesOfTimer.send(time.toTimeWithHoursMinutes())
            }
            .store(in: &cancellableBag)
    }

    //MARK: Input
    func startDoing() {
        if let startedDate = UserDefaults.standard.object(forKey: "start-time-of-doing") as? Date {
            self.startedDate = startedDate
            self.count.send(startedDate.distance(to: Date()))
        } else {
            startedDate = Date()
            UserDefaults.standard.set(startedDate, forKey: "start-time-of-doing")
        }
        startTimer()
    }
   
    func endDoing() {
        endedDate = Date()
    }
    
    func startTimer() {
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .map { $0.timeIntervalSince(self.startedDate ?? Date()) }
            .map { Double($0) }
            .sink {
                #if DEBUG
                print($0)
                #endif
                self.count.send($0)
            }
            .store(in: &cancellableBag)
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
    
    var startedTime = PassthroughSubject<String?, Never>()
    var timesOfTimer = CurrentValueSubject<String?, Never>("00:00")
    var isLessThanTime = CurrentValueSubject<Bool, Never>(true)

    func showCreateDid() {
        endDoing()
        if startedDate != nil, endedDate != nil {
            router?.showCreateDid(startedDate, endedDate)
        }
    }
    
    func cancel() {
        UserDefaults.standard.removeObject(forKey: "start-time-of-doing")
    }
    
    deinit {
        #if DEBUG
        print("Deinit Doing View Model")
        #endif
    }
}

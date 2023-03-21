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

    private func countSeconds() {
        count.value += 1
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
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let count = self?.count else { return }
            count.send(count.value + 1)
        }
        timer.fire()
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

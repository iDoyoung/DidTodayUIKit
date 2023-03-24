//
//  DoingViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/01.
//

import UIKit
import Combine

protocol DoingViewModelProtocol: DoingViewModelInput, DoingViewModelOutput {   }

protocol DoingViewModelInput {
    func startDoing()
    func showCreateDid()
    func cancelRecording()
    func observeDidEnterBackground()
}

protocol DoingViewModelOutput {
    var startedTime: PassthroughSubject<String?, Never> { get }
    var timesOfTimer: CurrentValueSubject<String?, Never> { get }
    var isLessThanTime: CurrentValueSubject<Bool, Never> { get }
}

final class DoingViewModel: DoingViewModelProtocol {
    
    //MARK: - Properties
    
    private var router: DoingRouter?
    private var cancellableBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .default)
        .autoconnect()
    
    //MARK: Output
    var startedDate = Just(UserDefaults.standard.object(forKey: "start-time-of-doing") as? Date)
        .replaceNil(with: Date())
        .eraseToAnyPublisher()
    
    var startedTime = PassthroughSubject<String?, Never>()
    var timesOfTimer = CurrentValueSubject<String?, Never>("00:00")
    var isLessThanTime = CurrentValueSubject<Bool, Never>(true)

    //MARK: - Method
    
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

    deinit {
        #if DEBUG
        print("Deinit Doing View Model")
        #endif
    }
    
    //MARK: Input
    func startDoing() {
        startedDate
            .sink { [weak self] date in
                self?.count.send(date.distance(to: Date()))
                self?.startTimer(date)
                let text = CustomText.started(time: date.currentTimeToString() )
                self?.startedTime.send(text)
            }
            .store(in: &cancellableBag)
    }
   
    
    func showCreateDid() {
        startedDate
            .sink { [weak self] startedDate in
                self?.router?.showCreateDid(startedDate, Date())
            }
            .store(in: &cancellableBag)
    }
    
    func cancelRecording() {
        UserDefaults.standard.removeObject(forKey: "start-time-of-doing")
    }
    
    func observeDidEnterBackground() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink() { [weak self] _ in
                self?.timerPublisher.upstream.connect().cancel()
            }
            .store(in: &cancellableBag)
    }
    
    private func startTimer(_ date: Date) {
        timerPublisher
            .map { $0.timeIntervalSince(date) }
            .map { Double($0) }
            .sink { [weak self] count in
                #if DEBUG
                print(count)
                #endif
                self?.count.send(count)
            }
            .store(in: &cancellableBag)
    }
}

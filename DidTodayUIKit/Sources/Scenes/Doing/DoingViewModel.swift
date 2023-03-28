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
    func updateCountWithStartedDate()
    func countTime()
    func viewDisappear()
    func showCreateDid()
    ///현재 기록 중인 데이터를 취소
    func cancelRecording()
    func observeDidEnterBackground()
    func observeWillEnterForeground()
}

protocol DoingViewModelOutput {
    var startedTimeText: AnyPublisher<String?, Never> { get }
    var timesOfTimer: CurrentValueSubject<String?, Never> { get }
    var isLessThanTime: CurrentValueSubject<Bool, Never> { get }
}

final class DoingViewModel: DoingViewModelProtocol {
    
    //MARK: - Properties
    
    private let router: DoingRouter?
    private var cancellableBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    private var startedDate: Date = {
        if let saved = UserDefaults.standard.object(forKey: "start-time-of-doing") as? Date {
            return saved
        } else {
            let current = Date()
            UserDefaults.standard.set(current, forKey: "start-time-of-doing")
            return current
        }
    }()
    
    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    //MARK: Output
    var startedTimeText: AnyPublisher<String?, Never>
    
    var timesOfTimer = CurrentValueSubject<String?, Never>("00:00")
    var isLessThanTime = CurrentValueSubject<Bool, Never>(true)

    //MARK: - Method
    
    init(router: DoingRouter) {
        self.router = router
        startedTimeText = Just(startedDate)
            .map { CustomText.started(time: $0.currentTimeToString()) }
            .eraseToAnyPublisher()
        
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
    func updateCountWithStartedDate() {
        count.send(startedDate.distance(to: Date()))
    }
    
    func countTime() {
        executeTimer(from: Date())
    }
  
    func showCreateDid() {
        router?.showCreateDid(startedDate, Date())
    }
    
    func cancelRecording() {
        UserDefaults.standard.removeObject(forKey: "start-time-of-doing")
    }
    
    func viewDisappear() {
        timerPublisher.upstream.connect().cancel()
    }
    
    func observeDidEnterBackground() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink() { [weak self] _ in
                self?.viewDisappear()
            }
            .store(in: &cancellableBag)
    }
    
    func observeWillEnterForeground() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink() { [weak self] _ in
                self?.countTime()
            }
            .store(in: &cancellableBag)
    }
    
    private func executeTimer(from date: Date) {
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

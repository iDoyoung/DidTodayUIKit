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
    
    func setStartedTimeText()
    ///현재 기록 중인 데이터를 취소
    func cancelRecording()
    func observeDidEnterBackground()
    func observeWillEnterForeground()
}

protocol DoingViewModelOutput {
    var startedTimeText: PassthroughSubject<String?, Never> { get }
    var timesOfTimer: CurrentValueSubject<String?, Never> { get }
    var isLessThanTime: CurrentValueSubject<Bool, Never> { get }
}

final class DoingViewModel: DoingViewModelProtocol {
    
    //MARK: - Properties
    
    private let router: DoingRouter?
    private var cancellableBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    ///User Default에 저장하기 위한 프로퍼티
    private var startedDate: AnyPublisher<Date, Never>
    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    //MARK: Output
    var startedTimeText = PassthroughSubject<String?, Never>()
    var timesOfTimer = CurrentValueSubject<String?, Never>("00:00")
    var isLessThanTime = CurrentValueSubject<Bool, Never>(true)

    //MARK: - Method
    
    init(router: DoingRouter) {
        self.router = router
        startedDate = Just(UserDefaults.standard.object(forKey: "start-time-of-doing") as? Date)
            .replaceNil(with: Date())
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
        startedDate
            .sink { [weak self] date in self?.count.send(date.distance(to: Date())) }
            .store(in: &cancellableBag)
    }
    
    func countTime() {
        startedDate
            .sink { [weak self] date in self?.executeTimer(from: date) }
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
    
    func setStartedTimeText() {
        startedDate
            .map { CustomText.started(time: $0.currentTimeToString()) }
            .sink { [weak self] text in self?.startedTimeText.send(text) }
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

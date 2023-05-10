//
//  DoingViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/01.
//

import UIKit
import Combine
import UserNotifications

protocol DoingViewModelProtocol: DoingViewModelInput, DoingViewModelOutput {   }

protocol DoingViewModelInput {
    func requestUserNotificationsAuthorization()
    func updateCountWithStartedDate()
    func countTime()
    func viewDisappear()
    func showCreateDid()
    ///현재 기록 중인 데이터를 취소
    func cancelRecording()
    func observeDidEnterBackground()
    func observeWillEnterForeground()
    func cancelUserNotifications()
}

protocol DoingViewModelOutput {
    var startedTimeText: AnyPublisher<String?, Never> { get }
    var timesOfTimer: CurrentValueSubject<String?, Never> { get }
    var isLessThanTime: CurrentValueSubject<Bool, Never> { get }
}

final class DoingViewModel: DoingViewModelProtocol {
    
    //MARK: - Properties
    
    private let router: DoingRouter?
    var cancellablesBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    ///테스트를 위해 Internal
    var startedDate: Date
    
    private var timerPublisher = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    //MARK: Output
    var startedTimeText: AnyPublisher<String?, Never>
    
    var timesOfTimer = CurrentValueSubject<String?, Never>("00:00")
    var isLessThanTime = CurrentValueSubject<Bool, Never>(true)

    //MARK: - Method
    
    init(router: DoingRouter) {
        self.router = router
        
        // Set up Started Date
        if let saved = UserDefaults.standard.object(forKey: "start-time-of-doing") as? Date {
            startedDate = saved
        } else {
            let current = Date()
            UserDefaults.standard.set(current, forKey: "start-time-of-doing")
            startedDate = current
        }
        
        startedTimeText = Just(startedDate)
            .map { CustomText.started(time: $0.currentTimeToString()) }
            .eraseToAnyPublisher()
        
        //Observe Count Time
        count
            .sink { [weak self] time in
                //TODO: Set time of minimum condition
                if self?.isLessThanTime.value == true, time >= (60*5) {
                    self?.isLessThanTime.send(false)
                }
                self?.timesOfTimer.send(time.toTimeWithHoursMinutes())
            }
            .store(in: &cancellablesBag)
    }

    deinit {
        #if DEBUG
        print("Deinit Doing View Model")
        #endif
    }
    
    //MARK: Input
     func requestUserNotificationsAuthorization() {
        AuthorizationManager.requestUserNotificationsAuthorization { [weak self] result in
            switch result {
            case .success(let authorizationStatus):
                #if DEBUG
                print("Succeeded requesting user notifications authorization \(String(describing: authorizationStatus))")
                #endif
                self?.requestUserNotification(with: "day-is-changed")
            case .failure(let error):
                #if DEBUG
                print("Failed requesting user notifications authorization \(String(describing: error))")
                #endif
            }
        }
    }
    
    func updateCountWithStartedDate() {
        count.send(startedDate.distance(to: Date()))
    }
    
    func countTime() {
        executeTimer(from: startedDate)
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
            .store(in: &cancellablesBag)
    }
    
    func observeWillEnterForeground() {
        NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink() { [weak self] _ in
                self?.countTime()
            }
            .store(in: &cancellablesBag)
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
            .store(in: &cancellablesBag)
    }
}

extension DoingViewModel: DayIsChangedNotification {
   
    func cancelUserNotifications() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["day-is-changed"])
    }
}

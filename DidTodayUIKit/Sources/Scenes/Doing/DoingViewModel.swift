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
    func setTitle(_ title: String)
    func setColorOfPie(red: Float, green: Float, blue: Float)
    func startDoing()
    func stopDoing()
    func createDid()
}

protocol DoingViewModelOutput {
    var timesOfTimer: CurrentValueSubject<String, Never> { get }
    var doneIsEnabled: CurrentValueSubject<Bool, Never> { get }
    var colorOfPie: CurrentValueSubject<Did.PieColor?, Never> { get }
    var titleOfDid: CurrentValueSubject<String?, Never> { get }
    var isSucceededCreated: CurrentValueSubject<Bool, Never> { get }
    var error: CurrentValueSubject<CoreDataStoreError?, Never> { get }
}

final class DoingViewModel: DoingViewModelProtocol {
    
    private var didCoreDataStorage: DidCoreDataStorable?
    private var timerManager: TimerManagerProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private var count = CurrentValueSubject<Double, Never>(0)
    
    init(timerManager: TimerManagerProtocol, didCoreDataStorage: DidCoreDataStorable) {
        self.didCoreDataStorage = didCoreDataStorage
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
    func setTitle(_ title: String) {
        titleOfDid.send(title)
    }
    
    func setColorOfPie(red: Float, green: Float, blue: Float) {
        let color = Did.PieColor(red: red,
                                 green: green,
                                 blue: blue,
                                 alpha: 1)
        colorOfPie.send(color)
    }
    
    func startDoing() {
        startedDate = Date()
        timerManager?.startTimer()
    }
    
    func stopDoing() {
        timerManager?.stopTimer()
    }
    
    func endDoing() {
        endedDate = Date()
        timerManager?.stopTimer()
    }
    
    func createDid() {
        guard let startedDate = startedDate,
              let endedDate = endedDate,
              let title = titleOfDid.value,
              let color = colorOfPie.value else { return }
        let did = Did(enforced: false, started: startedDate, finished: endedDate, content: title, color: color)
        didCoreDataStorage?.create(did) { [weak self] did, error in
            if error == nil {
                self?.isSucceededCreated.send(true)
            } else {
                self?.error.send(error)
            }
        }
    }
    
    //MARK: Output
    var startedDate: Date?
    var endedDate: Date?
    var timesOfTimer = CurrentValueSubject<String, Never>("00:00")
    var doneIsEnabled =  CurrentValueSubject<Bool, Never>(false)
    var colorOfPie = CurrentValueSubject<Did.PieColor?, Never>(nil)
    var titleOfDid = CurrentValueSubject<String?, Never>(nil)
    var isSucceededCreated = CurrentValueSubject<Bool, Never>(false)
    var error = CurrentValueSubject<CoreDataStoreError?, Never>(nil)
}

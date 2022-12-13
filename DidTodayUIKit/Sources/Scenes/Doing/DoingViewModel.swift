//
//  DoingViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/01.
//

import UIKit ///Is that Right?
import Combine

protocol DoingViewModelProtocol: DoingViewModelInput, DoingViewModelOutput {   }

protocol DoingViewModelInput {
    func setTitle(_ title: String)
    func setColorOfPie(_ color: UIColor)
    func startDoing()
    func stopDoing()
    func createDid()
}

protocol DoingViewModelOutput {
    var startedTime: PassthroughSubject<String, Never> { get }
    var timesOfTimer: CurrentValueSubject<String, Never> { get }
    var colorOfPie: CurrentValueSubject<UIColor, Never> { get }
    var titleOfDid: CurrentValueSubject<String?, Never> { get }
    var isSucceededCreated: CurrentValueSubject<Bool, Never> { get }
    var error: CurrentValueSubject<CoreDataStoreError?, Never> { get }
    var titleIsEmpty: CurrentValueSubject<Bool, Never> { get }
    var isLessThanTime: CurrentValueSubject<Bool, Never> { get }
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
        ///Observe Count Time
        count
            .sink { [weak self] time in
                if time == 60 {
                    self?.isLessThanTime.send(false)
                }
                self?.timesOfTimer.send(time.toTimeWithHoursMinutes())
            }
            .store(in: &cancellableBag)
        ///Observe Title Texts
        titleOfDid
            .sink { [weak self] text in
                if let text = text, !text.isEmpty {
                    self?.titleIsEmpty.send(false)
                } else {
                    self?.titleIsEmpty.send(true)
                }
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
    
    func setColorOfPie(_ color: UIColor) {
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
        timerManager?.stopTimer()
    }
    
    func createDid() {
        guard let startedDate = startedDate,
              let title = titleOfDid.value else { return }
        let did = Did(enforced: false,
                      started: startedDate,
                      finished: Date(),
                      content: title,
                      color: Did.PieColor(red: Float(colorOfPie.value.getRedOfRGB()),
                                          green: Float(colorOfPie.value.getGreenOfRGB()),
                                          blue: Float(colorOfPie.value.getBlueRGB()),
                                          alpha: Float(colorOfPie.value.getAlpha())))
        didCoreDataStorage?.create(did) { [weak self] did, error in
            if error == nil {
                self?.isSucceededCreated.send(true)
            } else {
                self?.error.send(error)
            }
        }
    }
    
    //MARK: Output
    ///It is output?. didSet is bad choice?
    var startedDate: Date? {
        didSet {
            startedTime.send("Started Time: \(startedDate?.currentTimeToString() ?? "00:00")")
        }
    }
    
    var startedTime = PassthroughSubject<String, Never>()
    var timesOfTimer = CurrentValueSubject<String, Never>("00:00")
    var colorOfPie = CurrentValueSubject<UIColor, Never>(.customGreen)
    var titleOfDid = CurrentValueSubject<String?, Never>(nil)
    var isSucceededCreated = CurrentValueSubject<Bool, Never>(false)
    var error = CurrentValueSubject<CoreDataStoreError?, Never>(nil)
    var titleIsEmpty =  CurrentValueSubject<Bool, Never>(true)
    var isLessThanTime = CurrentValueSubject<Bool, Never>(true)
}

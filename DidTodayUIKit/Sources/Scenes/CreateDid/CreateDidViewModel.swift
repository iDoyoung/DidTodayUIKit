//
//  CreateDidViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/19.
//

import UIKit
import Combine

enum CreateDidError: Error {
    case startedTimeError
    case coreDataError(CoreDataStoreError)
}

protocol CreateDidViewModelProtocol: CreateDidViewModelInput, CreateDidViewModelOutput {    }

protocol CreateDidViewModelInput {
    //MARK: - Input(Property vs Method)
    var startedTime: CurrentValueSubject<Date?, Never> { get }
    var endedTime: CurrentValueSubject<Date?, Never> { get }
    
    func setupFromDoing()
    func setTitle(_ title: String)
    func setColorOfPie(_ color: UIColor)
    func createDid() async
}

protocol CreateDidViewModelOutput {
    var title: CurrentValueSubject<String, Never> { get }
    var titleOfDid: CurrentValueSubject<String?, Never> { get }
    var titleIsEmpty: CurrentValueSubject<Bool, Never> { get }
    var colorOfPie: CurrentValueSubject<UIColor, Never> { get }
    var degreeOfStartedTime: CurrentValueSubject<Double?, Never> { get }
    var degreeOfEndedTime: CurrentValueSubject<Double?, Never> { get }
    var isCompleted: CurrentValueSubject<Bool, Never> { get }
    var creatingError: CurrentValueSubject<CoreDataStoreError?, Never> { get }
    var timePickerEnable: CurrentValueSubject<Bool, Never> { get }
    
    func initialStartedTime() -> Date
    func initialEndedTime() -> Date
}

final class CreateDidViewModel: CreateDidViewModelProtocol {
    
    //MARK: - Properties
    
    //MARK: Components
    var didCoreDataStorage: DidCoreDataStorable?
    private var cancellableBag = Set<AnyCancellable>()
    
    //MARK: - Input
    var startedTime = CurrentValueSubject<Date?, Never>(nil)
    var endedTime = CurrentValueSubject<Date?, Never>(Date())
    
    //MARK: - Output
    var title = CurrentValueSubject<String, Never>(CustomText.createDid)
    var titleOfDid = CurrentValueSubject<String?, Never>(nil)
    var titleIsEmpty = CurrentValueSubject<Bool, Never>(true)
    var degreeOfStartedTime = CurrentValueSubject<Double?, Never>(nil)
    var degreeOfEndedTime = CurrentValueSubject<Double?, Never>(nil)
    var colorOfPie = CurrentValueSubject<UIColor, Never>(.customGreen)
    var isCompleted = CurrentValueSubject<Bool, Never>(false)
    var creatingError = CurrentValueSubject<CoreDataStoreError?, Never>(nil)
    var timePickerEnable = CurrentValueSubject<Bool, Never>(true)
    
    //MARK: - Methods
    
    init(didCoreDataStorage: DidCoreDataStorable, startedDate: Date?, endedDate: Date?, fromDoing: Bool) {
        self.didCoreDataStorage = didCoreDataStorage
        
        startedTime
            .compactMap { $0?.timesCalculateToMinutes() }
            .map { Double($0) * 0.25 }
            .sink { [weak self] output in
                self?.degreeOfStartedTime.send(output)
            }
            .store(in: &cancellableBag)
        
        endedTime
            .compactMap { $0?.timesCalculateToMinutes() }
            .map { Double($0) * 0.25 }
            .sink { [weak self] output in
                self?.degreeOfEndedTime.send(output)
            }
            .store(in: &cancellableBag)
        
        startedTime.send(startedDate)
        endedTime.send(endedDate)
        if fromDoing { setupFromDoing() }
    }
    
    //MARK: - Input
    func setupFromDoing() {
        timePickerEnable.send(false)
        title.send(CustomText.finishingTouches)
    }
    
    func setTitle(_ title: String) {
        titleOfDid.send(title)
        if title.isEmpty {
            titleIsEmpty.send(true)
        } else {
            titleIsEmpty.send(false)
        }
    }
    
    func setColorOfPie(_ color: UIColor) {
        colorOfPie.send(color)
    }
    
    func createDid() async {
        guard let startedTime = startedTime.value,
              let endedTime = endedTime.value,
              let title = titleOfDid.value else {
            return
        }
        //TODO: Refactor Better
        let isRecordedTime = !timePickerEnable.value
        let color = Did.PieColor(red: Float(colorOfPie.value.getRedOfRGB()),
                                 green: Float(colorOfPie.value.getGreenOfRGB()),
                                 blue: Float(colorOfPie.value.getBlueRGB()),
                                 alpha: Float(colorOfPie.value.getAlpha()))
        let did = Did(withTimer: isRecordedTime,
                      started: startedTime,
                      finished: endedTime,
                      content: title,
                      color: color)
        do {
            try await didCoreDataStorage?.create(did)
            isCompleted.send(true)
        } catch let error {
            if let coreDataError = error as? CoreDataStoreError {
                creatingError.send(coreDataError)
            }
        }
    }
    
    //MARK: - Output
    func initialStartedTime() -> Date {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        if let startedTime = startedTime.value {
            return startedTime
        } else {
            return startOfDay
        }
    }
    
    func initialEndedTime() -> Date {
        if let endedTime = endedTime.value {
            return endedTime
        } else {
            return Date()
        }
    }
    
    deinit {
        #if DEBUG
        print("Deinit Create Did View Model")
        #endif
    }
}

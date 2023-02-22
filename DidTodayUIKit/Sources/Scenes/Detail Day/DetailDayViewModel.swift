//
//  DetailDayViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/06.
//

import Foundation
import Combine

protocol DetailDayViewModelProtocol: DetailDayViewModelInput, DetailDayViewModelOutput {  }

protocol DetailDayViewModelInput {
    func selectRecently()
    func selectMuchTime()
}

protocol DetailDayViewModelOutput {
    var selectedDay: CurrentValueSubject<String?, Never> { get }
    var totalPieDids: CurrentValueSubject<TotalOfDidsItemViewModel, Never> { get }
    var didItemsList: CurrentValueSubject<[DidItemViewModel], Never> { get }
    var isSelectedRecentlyButton: CurrentValueSubject<Bool, Never> { get }
    var isSelectedMuchTimeButton: CurrentValueSubject<Bool, Never> { get }
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    
    //MARK: - Properties
    
    //MARK: Output
    var selectedDay = CurrentValueSubject<String?, Never>(nil)
    var totalPieDids = CurrentValueSubject<TotalOfDidsItemViewModel, Never>(TotalOfDidsItemViewModel([]))
    var didItemsList = CurrentValueSubject<[DidItemViewModel], Never>([])
    var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
    var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(false)
    
    //MARK: - Methods
    
    init(selected: Date, dids: [Did]) {
        let totalItems = TotalOfDidsItemViewModel(dids)
        let didItems = dids
            .sorted { $0.started > $1.started }
            .map { DidItemViewModel($0) }
        totalPieDids.send(totalItems)
        didItemsList.send(didItems)
        selectedDay.send(selected.toString())
    }
    
    //MARK: Input
    func selectRecently() {
        if !isSelectedRecentlyButton.value {
            isSelectedRecentlyButton.send(true)
            isSelectedMuchTimeButton.send(false)
            sortByRecently()
        }
    }
    
    func selectMuchTime() {
        if !isSelectedMuchTimeButton.value {
            isSelectedMuchTimeButton.send(true)
            isSelectedRecentlyButton.send(false)
            sortByMuchTime()
        }
    }
    
    //MARK: Private
    private func sortByRecently() {
        didItemsList.value.sort { $0.startedTimes > $1.startedTimes }
    }
    
    private func sortByMuchTime() {
        didItemsList.value.sort { ($0.finishedTimes - $0.startedTimes) > ($1.finishedTimes - $1.startedTimes) }
    }
}

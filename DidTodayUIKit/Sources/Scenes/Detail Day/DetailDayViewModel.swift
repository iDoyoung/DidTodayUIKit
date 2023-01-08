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
    var totalPieDids: CurrentValueSubject<TotalOfDidsItemViewModel, Never> { get }
    var didItemsList: CurrentValueSubject<[DidItemViewModel], Never> { get }
    var isSelectedRecentlyButton: CurrentValueSubject<Bool, Never> { get }
    var isSelectedMuchTimeButton: CurrentValueSubject<Bool, Never> { get }
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    
    init(dids: [Did]) {
        let totalItems = TotalOfDidsItemViewModel(dids)
        let didItems = dids.map { DidItemViewModel($0) }
        totalPieDids.send(totalItems)
        didItemsList.send(didItems)
    }
    
    //MARK: - Input
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
    
    private func sortByRecently() {
        didItemsList.value.sort { $0.startedTimes > $1.startedTimes }
    }
    
    private func sortByMuchTime() {
        didItemsList.value.sort { ($0.finishedTimes - $0.startedTimes) > ($1.finishedTimes - $1.startedTimes) }
    }
    
    //MARK: - Output
    var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
    var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(false)
    var totalPieDids = CurrentValueSubject<TotalOfDidsItemViewModel, Never>(TotalOfDidsItemViewModel([]))
    var didItemsList = CurrentValueSubject<[DidItemViewModel], Never>([])
}

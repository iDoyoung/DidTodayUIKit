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
}

protocol DetailDayViewModelOutput {
    var totalPieDids: CurrentValueSubject<TotalOfDidsItemViewModel, Never> { get }
    var didItemsList: CurrentValueSubject<[DidItemViewModel], Never> { get }
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    
    init(dids: [Did]) {
        let totalItems = TotalOfDidsItemViewModel(dids)
        let didItems = dids.map { DidItemViewModel($0) }
        totalPieDids.send(totalItems)
        didItemsList.send(didItems)
    }
    
    //MARK: - Output
    var totalPieDids = CurrentValueSubject<TotalOfDidsItemViewModel, Never>(TotalOfDidsItemViewModel([]))
    var didItemsList = CurrentValueSubject<[DidItemViewModel], Never>([])
}

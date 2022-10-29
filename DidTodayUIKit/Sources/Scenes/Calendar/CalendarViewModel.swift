//
//  CalendarViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/28.
//

import Foundation

protocol CalendarViewModelProtocol: CalendarViewModelInput, CalendarViewModelOutput {   }

protocol CalendarViewModelInput {
    var dids: [MainDidItemsViewModel] { get }
}

protocol CalendarViewModelOutput {
    var didsPublisher: Published<[MainDidItemsViewModel]>.Publisher { get }
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    @Published var dids: [MainDidItemsViewModel]
    var didsPublisher: Published<[MainDidItemsViewModel]>.Publisher { $dids }
    
    init(dids: [MainDidItemsViewModel]) {
        self.dids = dids
    }
}

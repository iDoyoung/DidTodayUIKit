//
//  CalendarViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/28.
//

import Foundation

protocol CalendarViewModelProtocol: CalendarViewModelInput, CalendarViewModelOutput {   }

protocol CalendarViewModelInput {
    var dids: [Did] { get }
}

protocol CalendarViewModelOutput {
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    @Published var dids: [Did]
    
    init(dids: [Did]) {
        self.dids = dids
    }
}

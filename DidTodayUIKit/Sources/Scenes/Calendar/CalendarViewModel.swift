//
//  CalendarViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/28.
//

import Foundation
import Combine

protocol CalendarViewModelProtocol: CalendarViewModelInput, CalendarViewModelOutput {   }

protocol CalendarViewModelInput {
    var dids: [Did] { get }
}

protocol CalendarViewModelOutput {
    var dateOfDids: [Date] { get }
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    //MARK: - Input
    var dids: [Did]
    
    //MARK: - Output
    @Published var dateOfDids: [Date]
    
    init(dids: [Did]) {
        self.dids = dids
        let dates = dids.map { $0.started.omittedTime() }
        self.dateOfDids = Array(Set(dates))
    }
}

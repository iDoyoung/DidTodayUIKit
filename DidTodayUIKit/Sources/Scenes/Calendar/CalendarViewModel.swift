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
    var selectedDay: DateComponents? { get set }
}

protocol CalendarViewModelOutput {
    var dateOfDidsPublisher: Published<[Date]>.Publisher { get }
    var startedDate: Date? { get }
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    private var cancellableBag = Set<AnyCancellable>()
    //MARK: - Input
    @Published var dids: [Did]
    @Published var selectedDay: DateComponents?
    
    //MARK: - Output
    @Published private var dateOfDids: [Date]
    var dateOfDidsPublisher: Published<[Date]>.Publisher {
        $dateOfDids
    }
    var startedDate: Date?
    var titleDidsOfDateSubject = PassthroughSubject<[String], Never>()

    init(dids: [Did]) {
        self.dids = dids
        let dates = dids.map { $0.started.omittedTime() }
        self.startedDate = dates.first ?? Date()
        self.dateOfDids = Array(Set(dates))
        $selectedDay.sink { [weak self] day in
            let titleOfdids = dids
                .filter { $0.started.omittedTime() == day?.date?.omittedTime() }
                .map { $0.content }
            self?.titleDidsOfDateSubject.send(titleOfdids)
        }
        .store(in: &cancellableBag)
    }
}

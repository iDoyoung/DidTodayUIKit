//
//  CalendarViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/28.
//

import UIKit
import Combine

protocol CalendarViewModelProtocol: CalendarViewModelInput, CalendarViewModelOutput {   }

protocol CalendarViewModelInput {
    var dids: [Did] { get }
    var selectedDay: DateComponents? { get set }
}

protocol CalendarViewModelOutput {
    var dateOfDids: CurrentValueSubject<[Date], Never> { get }
    var didsOfDayItem: CurrentValueSubject<[DidsOfDayItemViewModel], Never> { get }
    var descriptionOfSelectedDay: CurrentValueSubject<String?, Never> { get }
    var startedDate: Date? { get }
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    private var cancellableBag = Set<AnyCancellable>()
    
    init(dids: [Did]) {
        self.dids = dids
        let dates = dids.map { $0.started.omittedTime() }
        self.startedDate = dates.first ?? Date()
        dateOfDids.send(dates)
        $selectedDay
            .sink { [weak self] day in
                guard let day = day else { return }
                let item = dids
                    .filter { $0.started.omittedTime() == Calendar.current.date(from: day)?.omittedTime() }
                    .map { DidsOfDayItemViewModel($0) }
                self?.didsOfDayItem.send(item)
                if item.count == 0 {
                    self?.descriptionOfSelectedDay.send("Dids \(item.count) Things")
                }
            }
            .store(in: &cancellableBag)
    }
   
    //MARK: - Input
    @Published var dids: [Did]
    @Published var selectedDay: DateComponents?
    
    //MARK: - Output
    var dateOfDids = CurrentValueSubject<[Date], Never>([])
    var startedDate: Date?
    var descriptionOfSelectedDay = CurrentValueSubject<String?, Never>(nil)
    var didsOfDayItem = CurrentValueSubject<[DidsOfDayItemViewModel], Never>([])
}

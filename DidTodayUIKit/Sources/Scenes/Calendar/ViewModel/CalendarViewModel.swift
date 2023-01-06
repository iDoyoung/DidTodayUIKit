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
    var selectedDay: DateComponents? { get set }
    func fetchDids()
}

protocol CalendarViewModelOutput {
    var fetchedDids: CurrentValueSubject<[Did], Never> { get }
    var dateOfDids: CurrentValueSubject<[Date], Never> { get }
    var itemsOfselectedDay: CurrentValueSubject<[DidsOfDayItemViewModel], Never> { get }
    var descriptionOfSelectedDay: CurrentValueSubject<String?, Never> { get }
    var startedDate: Date? { get }
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    private var didCoreDataStorage: DidCoreDataStorable?
    private var router: CalendarRouter?
    private var cancellableBag = Set<AnyCancellable>()
    
    init(didCoreDataStorage: DidCoreDataStorable, router: CalendarRouter) {
        self.didCoreDataStorage = didCoreDataStorage
        self.router = router
        
        fetchedDids
            .sink { [weak self] dids in
                let dates = dids.map { $0.started.omittedTime() }
                self?.startedDate = dates.first ?? Date()
                self?.dateOfDids.send(dates)
            }
            .store(in: &cancellableBag)
        
        $selectedDay
            .sink { [weak self] day in
                guard let theDay = day ,
                      let theSelf = self else { return }
                
                let item = theSelf.fetchedDids.value
                    .filter { $0.started.omittedTime() == Calendar.current.date(from: theDay)?.omittedTime() }
                    .compactMap { DidsOfDayItemViewModel($0) }
                theSelf.itemsOfselectedDay.send(item)
                
                /// - Tag: Setting Description Label
                if item.isEmpty {
                    theSelf.descriptionOfSelectedDay.send("Select Day")
                } else {
                    theSelf.descriptionOfSelectedDay.send("Did \(item.count) Things")
                }
            }
            .store(in: &cancellableBag)
        selectedDay = nil
    }
   
    //MARK: - Input
    @Published var selectedDay: DateComponents?
    
    func fetchDids() {
        didCoreDataStorage?.fetchDids { [weak self] dids, error in
            guard let theSelf = self else { return }
            if error == nil {
                theSelf.fetchedDids.send(dids)
            } else {
                //TODO: Alert 사용해서 Core Data Fetch 실패를 알려야 하나
                #if DEBUG
                print("Error: \(String(describing: error))")
                #endif
            }
        }
    }
    
    //MARK: - Output
    var fetchedDids = CurrentValueSubject<[Did], Never>([])
    var dateOfDids = CurrentValueSubject<[Date], Never>([])
    var startedDate: Date?
    var descriptionOfSelectedDay = CurrentValueSubject<String?, Never>("Select Day")
    var itemsOfselectedDay = CurrentValueSubject<[DidsOfDayItemViewModel], Never>([])
}

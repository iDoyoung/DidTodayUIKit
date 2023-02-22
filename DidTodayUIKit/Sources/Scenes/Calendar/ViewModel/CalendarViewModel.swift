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
    var itemsOfDidSelectedDay: CurrentValueSubject<[DidsOfDayItemViewModel], Never> { get }
    var descriptionOfSelectedDay: CurrentValueSubject<String?, Never> { get }
    var startedDate: Date? { get }
    
    func showDetail()
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    //MARK: - Properties
    private var didCoreDataStorage: DidCoreDataStorable?
    private var router: CalendarRouter?
    private var cancellableBag = Set<AnyCancellable>()
    
    //MARK: Output
    var fetchedDids = CurrentValueSubject<[Did], Never>([])
    var dateOfDids = CurrentValueSubject<[Date], Never>([])
    var startedDate: Date?
    var itemsOfDidSelectedDay = CurrentValueSubject<[DidsOfDayItemViewModel], Never>([])
    var descriptionOfSelectedDay = CurrentValueSubject<String?, Never>(CustomText.selectDay)
    
    private var didsSelectedDay = CurrentValueSubject<[Did], Never>([])
        
    //MARK: - Methods
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
                guard let day,
                      let self else { return }
                let item = self.fetchedDids.value
                    .filter { $0.started.omittedTime() == Calendar.current.date(from: day)?.omittedTime() }
                self.didsSelectedDay.send(item)
                /// - Tag: Setting Description Label
                if item.isEmpty {
                    self.descriptionOfSelectedDay.send(CustomText.selectDay)
                } else {
                    self.descriptionOfSelectedDay.send(CustomText.selectedItems(count: item.count))
                }
            }
            .store(in: &cancellableBag)
        selectedDay = nil
        
        didsSelectedDay
            .sink { [weak self] output in
                let items = output.compactMap { DidsOfDayItemViewModel($0) }
                self?.itemsOfDidSelectedDay.send(items)
            }
            .store(in: &cancellableBag)
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
    
    
    func showDetail() {
        guard let theSelectedDay = selectedDay,
              let theSelectedDate = Calendar.current.date(from: theSelectedDay) else { return }
        let dids = didsSelectedDay.value
        router?.showDetailDay(theSelectedDate, dids)
    }
    
    deinit {
        #if DEBUG
        print("Deinit Calendar View Model")
        #endif
    }
}

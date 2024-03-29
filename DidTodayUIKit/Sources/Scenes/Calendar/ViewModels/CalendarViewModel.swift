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
    var displayedItemsOfDidSelectedDay: CurrentValueSubject<[DidsOfDayItemViewModel], Never> { get }
    var descriptionOfSelectedDay: CurrentValueSubject<String?, Never> { get }
    var startedDate: Date? { get }
    var selectedDate: CurrentValueSubject<Date?, Never> { get }
    
    func showDetail()
}

final class CalendarViewModel: CalendarViewModelProtocol {
    
    //MARK: - Properties
    private var fetchDidUseCase: FetchDidUseCase?
    private var router: CalendarRouter?
    private var cancellableBag = Set<AnyCancellable>()
    
    //MARK: Input
    @Published var selectedDay: DateComponents?
    
    //MARK: Output
    var fetchedDids = CurrentValueSubject<[Did], Never>([])
    ///Didplay mark of date of did something in Calendar
    var dateOfDids = CurrentValueSubject<[Date], Never>([])
    ///Set started date of Calendar
    var startedDate: Date?
    var selectedDate = CurrentValueSubject<Date?, Never>(nil)
    var displayedItemsOfDidSelectedDay = CurrentValueSubject<[DidsOfDayItemViewModel], Never>([])
    var descriptionOfSelectedDay = CurrentValueSubject<String?, Never>(CustomText.selectDay)
        
    //MARK: - Methods
    init(fetchDidUseCase: FetchDidUseCase, router: CalendarRouter) {
        self.fetchDidUseCase = fetchDidUseCase
        self.router = router
        
        //TODO: Refactoring, Details Did에서 돌아왔을 경우 고려해서 리펙토링
        fetchedDids
            .sink { [weak self] dids in
                guard let self else { return }
                let dates = dids.map { $0.finished.omittedTime() }
                self.startedDate = dates.first ?? Date()
                self.dateOfDids.send(dates)
                
                if let selectedDay = self.selectedDay {
                    let item = self.fetchedDids.value
                        .filter { $0.finished.omittedTime() == Calendar.current.date(from: selectedDay)?.omittedTime() }
                        .compactMap { DidsOfDayItemViewModel($0) }
                    self.displayedItemsOfDidSelectedDay.send(item)
                }
            }
            .store(in: &cancellableBag)
        
        $selectedDay
            .sink { [weak self] day in
                guard let day,
                      let self else { return }
                let item = self.fetchedDids.value
                    .filter { $0.finished.omittedTime() == Calendar.current.date(from: day)?.omittedTime() }
                    .compactMap { DidsOfDayItemViewModel($0) }
                /// - Tag: Setting Description Label
                let description = item.isEmpty ? CustomText.selectDay: CustomText.selectedItems(count: item.count)
                self.selectedDate.send(Calendar.current.date(from: day))
                self.displayedItemsOfDidSelectedDay.send(item)
                self.descriptionOfSelectedDay.send(description)
            }
            .store(in: &cancellableBag)
    }
    
    deinit {
        #if DEBUG
        print("Deinit Calendar View Model")
        #endif
    }
    
    //MARK: - Input
    func fetchDids() {
        Task {
            guard let fetched = try await fetchDidUseCase?.execute() else { return }
            fetchedDids.send(fetched)
            //TODO: Alert 사용해서 Core Data Fetch 실패를 알려야 하나
        }
    }
    
    
    func showDetail() {
        guard let theSelectedDay = selectedDay,
              let theSelectedDate = Calendar.current.date(from: theSelectedDay) else { return }
        router?.showDetailDay(theSelectedDate)
    }
}

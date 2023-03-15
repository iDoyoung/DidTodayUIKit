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
    func fetchDids()
    func selectRecently()
    func selectMuchTime()
    func didSelectItem(at index: Int)
}

protocol DetailDayViewModelOutput {
    var selectedDay: CurrentValueSubject<String?, Never> { get }
    var totalPieDids: CurrentValueSubject<TotalOfDidsItemViewModel, Never> { get }
    var didItemsList: CurrentValueSubject<[DidItemViewModel], Never> { get }
    var isSelectedRecentlyButton: CurrentValueSubject<Bool, Never> { get }
    var isSelectedMuchTimeButton: CurrentValueSubject<Bool, Never> { get }
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    
    //MARK: - Properties
    
    var router: DetailDayRouter?
    var fetchDidUseCase: FetchDidUseCase?
    private var cancellableBag = Set<AnyCancellable>()
    
    private var fetchedDids = CurrentValueSubject<[Did], Never>([])
    private var selectedDate: Date
    //MARK: Output
    var selectedDay = CurrentValueSubject<String?, Never>(nil)
    var totalPieDids = CurrentValueSubject<TotalOfDidsItemViewModel, Never>(TotalOfDidsItemViewModel([]))
    var didItemsList = CurrentValueSubject<[DidItemViewModel], Never>([])
    var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
    var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(false)
    
    //MARK: - Methods
    
    init(selected: Date) {
        selectedDate = selected
        fetchedDids
            .sink { [weak self] items in
                let output = items.map { DidItemViewModel($0) }
                self?.didItemsList.send(output)
            }
            .store(in: &cancellableBag)
        
        selectedDay.send(selected.toString())
    }
    
    //MARK: Input
    func fetchDids() {
        Task {
            guard let fetched = try await fetchDidUseCase?.executeFiltered(by: selectedDate) else { return }
            if isSelectedMuchTimeButton.value {
                fetchedDids.send(fetched.sorted { Date.differenceToMinutes(from: $0.started, to: $0.finished) > Date.differenceToMinutes(from: $1.started, to: $1.finished) })
            } else {
                fetchedDids.send(fetched.sorted { $0.started > $1.started})
            }
            totalPieDids.send(TotalOfDidsItemViewModel(fetchedDids.value))
            //TODO: Alert 사용해서 Core Data Fetch 실패를 알려야 하나
        }
    }
    
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
    
    func didSelectItem(at index: Int) {
        router?.showDidDetails(fetchedDids.value[index])
    }
    
    //MARK: Private
    private func sortByRecently() {
        let sorted = fetchedDids.value.sorted { $0.started > $1.started }
        fetchedDids.send(sorted)
    }
    
    private func sortByMuchTime() {
        let sorted = fetchedDids.value.sorted {
            Date.differenceToMinutes(from: $0.started, to: $0.finished) > Date.differenceToMinutes(from: $1.started, to: $1.finished)
        }
        fetchedDids.send(sorted)
    }
}

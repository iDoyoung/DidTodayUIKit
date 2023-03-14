//
//  MainViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/15.
//

import Combine
import Foundation

protocol MainViewModelProtocol: MainViewModelInput, MainViewModelOutput {   }

protocol MainViewModelInput {
    func fetchDids()
    func selectRecently()
    func selectMuchTime()
    func removeRecorded()
    func didSelectItem(at index: Int)
}

protocol MainViewModelOutput {
    var hasRecordedBeforeClose: Just<Date?> { get }
    var totalPieDids: CurrentValueSubject<TotalOfDidsItemViewModel, Never> { get }
    var didItemsList: CurrentValueSubject<[DidItemViewModel], Never> { get }
    var isSelectedRecentlyButton: CurrentValueSubject<Bool, Never> { get }
    var isSelectedMuchTimeButton: CurrentValueSubject<Bool, Never> { get }
    
    func showAbout()
    func showDoing()
    func showCreateDid()
    func showCalendar()
}

final class MainViewModel: MainViewModelProtocol {
    
    //MARK: - Properties
    
    //MARK: Components
    private var fetchDidUseCase: FetchDidUseCase?
    private var router: MainRouter?
    private var cancellableBag = Set<AnyCancellable>()
    
    //MARK: Output, data store
    private var fetchedDids = CurrentValueSubject<[Did], Never>([])
    var hasRecordedBeforeClose = Just(UserDefaults.standard.object(forKey: "start-time-of-doing") as? Date)
    var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
    var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(false)
    var totalPieDids = CurrentValueSubject<TotalOfDidsItemViewModel, Never>(TotalOfDidsItemViewModel([]))
    var didItemsList = CurrentValueSubject<[DidItemViewModel], Never>([])
    
    //MARK: - Method
    init(fetchDidUseCase: FetchDidUseCase, router: MainRouter) {
        self.fetchDidUseCase = fetchDidUseCase
        self.router = router
        
        fetchedDids
            .sink { [weak self] items in
                let output = items.map { DidItemViewModel($0) }
                self?.didItemsList.send(output)
            }
            .store(in: &cancellableBag)
    }
    
    //MARK: - Input
    func fetchDids() {
        Task {
            guard let fetched = try await fetchDidUseCase?.executeFilteredByToday() else { return }
            fetchedDids.send(fetched.sorted { $0.started > $1.started})
            totalPieDids.send(TotalOfDidsItemViewModel(fetchedDids.value))
            //TODO: Alert 사용해서 Core Data Fetch 실패를 알려야 하나
        }
    }
    
    func removeRecorded() {
        UserDefaults.standard.removeObject(forKey: "start-time-of-doing")
    }
    
    //MARK: View event methods
    func selectRecently() {
        if !isSelectedRecentlyButton.value {
            isSelectedRecentlyButton.value = true
            isSelectedMuchTimeButton.value = false
            sortByRecently()
        }
    }
    
    func selectMuchTime() {
        if !isSelectedMuchTimeButton.value {
            isSelectedMuchTimeButton.value = true
            isSelectedRecentlyButton.value = false
            sortByMuchTime()
        }
    }

    private func sortByRecently() {
        let sorted = fetchedDids.value.sorted { $0.started > $1.started }
        fetchedDids.send(sorted)
    }
    
    private func sortByMuchTime() {
        didItemsList.value.sort { ($0.finishedTimes - $0.startedTimes) > ($1.finishedTimes - $1.startedTimes) }
        let sorted = fetchedDids.value.sorted { Date.differenceToMinutes(from: $0.started, to: $0.finished) > Date.differenceToMinutes(from: $1.started, to: $1.finished) }
        fetchedDids.send(sorted)
    }
    
    //MARK: - Output, Flow method
    func showCreateDid() {
        if didItemsList.value.isEmpty {
            router?.showCreateDid(nil, nil)
        } else {
            let recenlyFinishedDid = fetchedDids.value.max { $0.finished < $1.finished }
            router?.showCreateDid(recenlyFinishedDid?.finished, nil)
        }
    }
    
    func didSelectItem(at index: Int) {
        router?.showDidDetails(fetchedDids.value[index])
    }
    
    func showCalendar() {
        router?.showCalendar()
    }
    
    func showDoing() {
        router?.showDoing()
    }
    
    func showAbout() {
        router?.showInformation()
    }
}

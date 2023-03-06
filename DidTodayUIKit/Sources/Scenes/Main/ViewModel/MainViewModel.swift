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
        let calendar = Calendar.current
        fetchedDids
            .map {
                $0
                    .filter { calendar.isDateInToday($0.started) }
                    .map { DidItemViewModel($0) }
                    .sorted { $0.startedTimes > $1.startedTimes }
            }
            .sink { [weak self] items in
                self?.didItemsList.send(items)
            }
            .store(in: &cancellableBag)
        fetchedDids
            .map {
                let output = $0.filter { calendar.isDateInToday($0.started) }
                return TotalOfDidsItemViewModel(output)
            }
            .sink { [weak self] item in
                self?.totalPieDids.send(item)
            }
            .store(in: &cancellableBag)
    }
    
    //MARK: - Input
    func fetchDids() {
        Task {
            guard let fetched = try await fetchDidUseCase?.execute() else { return }
            fetchedDids.send(fetched)
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
        didItemsList.value.sort { $0.startedTimes > $1.startedTimes }
    }
    
    private func sortByMuchTime() {
        didItemsList.value.sort { ($0.finishedTimes - $0.startedTimes) > ($1.finishedTimes - $1.startedTimes) }
    }
    
    //MARK: - Output, Flow method
    func showCreateDid() {
        if didItemsList.value.isEmpty {
            router?.showCreateDid(nil, nil)
        } else if let theLastOfDids = fetchedDids.value.last {
            router?.showCreateDid(theLastOfDids.finished, nil)
        }
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

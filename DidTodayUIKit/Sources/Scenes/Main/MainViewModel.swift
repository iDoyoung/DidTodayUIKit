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
    func showInformation()
}

protocol MainViewModelOutput {
    var totalPieDids: CurrentValueSubject<MainTotalOfDidsItemViewModel, Never> { get }
    var didItemsList: CurrentValueSubject<[MainDidItemsViewModel], Never> { get }
    var isSelectedRecentlyButton: CurrentValueSubject<Bool, Never> { get }
    var isSelectedMuchTimeButton: CurrentValueSubject<Bool, Never> { get }
    
    func showDoing()
    func showCreateDid()
    func showCalendar()
}

final class MainViewModel: MainViewModelProtocol {
    
    private var didCoreDataStorage: DidCoreDataStorable?
    private var router: MainRouter?
    private var cancellableBag = Set<AnyCancellable>()
    
    init(didCoreDataStorage: DidCoreDataStorable, router: MainRouter) {
        self.didCoreDataStorage = didCoreDataStorage
        self.router = router
        let calendar = Calendar.current
        fetchedDids
            .map {
                $0
                    .filter { calendar.isDateInToday($0.started) }
                    .map { MainDidItemsViewModel($0) }
                    .sorted { $0.startedTimes > $1.startedTimes }
            }
            .sink { [weak self] items in
                self?.didItemsList.send(items)
            }
            .store(in: &cancellableBag)
        fetchedDids
            .map {
                let output = $0.filter { calendar.isDateInToday($0.started) }
                return MainTotalOfDidsItemViewModel(output)
            }
            .sink { [weak self] item in
                self?.totalPieDids.send(item)
            }
            .store(in: &cancellableBag)
    }
    
    //MARK: - Input
    func fetchDids() {
        didCoreDataStorage?.fetchDids { [weak self] dids, error in
            guard let self = self else { return }
            if error == nil {
                self.fetchedDids.send(dids)
            } else {
                //TODO: Alert 사용해서 Core Data Fetch 실패를 알려야 하나
                #if DEBUG
                print("Error: \(String(describing: error))")
                #endif
            }
        }
    }
    
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
        didItemsList.value.sort { $0.startedTimes < $1.startedTimes }
    }
    
    private func sortByMuchTime() {
        didItemsList.value.sort { ($0.finishedTimes - $0.startedTimes) > ($1.finishedTimes - $1.startedTimes) }
    }
    
    //MARK: - Output
    private var fetchedDids = CurrentValueSubject<[Did], Never>([])
    var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
    var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(false)
    var totalPieDids = CurrentValueSubject<MainTotalOfDidsItemViewModel, Never>(MainTotalOfDidsItemViewModel([]))
    var didItemsList = CurrentValueSubject<[MainDidItemsViewModel], Never>([])
    
    func showCreateDid() {
        guard let recentDid = fetchedDids.value.last else {
            router?.showCreateDid(nil, nil)
           return
        }
        router?.showCreateDid(recentDid.finished, nil)
    }
    
    func showCalendar() {
        let dids = fetchedDids.value
        router?.showCalendar(dids)
    }
    
    func showDoing() {
        router?.showDoing()
    }
    
    func showInformation() {
        router?.showInformation()
    }
}

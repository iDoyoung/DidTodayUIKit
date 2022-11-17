//
//  MainViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/15.
//

import Combine

protocol MainViewModelProtocol: MainViewModelInput, MainViewModelOutput {   }

protocol MainViewModelInput {
    func fetchDids()
    func selectRecently()
    func selectMuchTime()
}

protocol MainViewModelOutput {
    var didItemsPublisher: Published<[MainDidItemsViewModel]>.Publisher { get }
    var isSelectedRecentlyButton: CurrentValueSubject<Bool, Never> { get }
    var isSelectedMuchTimeButton: CurrentValueSubject<Bool, Never> { get }
    var totalPieDids: CurrentValueSubject<MainTotalOfDidsItemViewModel, Never> { get }
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
        fetchedDids
            .map { $0.map { MainDidItemsViewModel($0) }}
            .sink { [weak self] items in
                self?.itemsListDids.send(items)
            }
            .store(in: &cancellableBag)
        fetchedDids
            .map { MainTotalOfDidsItemViewModel($0) }
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
                let output = dids.sorted { $0.started < $1.started }
                self.fetchedDids.send(output)
//                self.didsItem = dids
//                    .sorted { $0.started < $1.started }
//                    .map { MainDidItemsViewModel($0) }
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
        didsItem.sort { $0.startedTimes < $1.startedTimes }
    }
    
    private func sortByMuchTime() {
        didsItem.sort { ($0.finishedTimes - $0.startedTimes) < ($1.finishedTimes - $1.startedTimes) }
    }
    
    //MARK: - Output
    private var fetchedDids = CurrentValueSubject<[Did], Never>([])
    var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
    var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(false)
    var totalPieDids = CurrentValueSubject<MainTotalOfDidsItemViewModel, Never>(MainTotalOfDidsItemViewModel([]))
    var itemsListDids = CurrentValueSubject<[MainDidItemsViewModel], Never>([])
    
    @Published private var didsItem: [MainDidItemsViewModel] = []
    var didItemsPublisher: Published<[MainDidItemsViewModel]>.Publisher {
        $didsItem
    }
    
    func showCreateDid() {
        router?.showCreateDid()
    }
    
    func showCalendar() {
        let dids = fetchedDids.value
        router?.showCalendar(dids)
    }
}

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
}

protocol MainViewModelOutput {
    var didItemsPublisher: Published<[MainDidItemsViewModel]>.Publisher { get }
    func showCreateDid()
    func showCalendar()
}

final class MainViewModel: MainViewModelProtocol {
    
    private var didCoreDataStorage: DidCoreDataStorable?
    private var router: MainRouter?
    
    init(didCoreDataStorage: DidCoreDataStorable, router: MainRouter) {
        self.didCoreDataStorage = didCoreDataStorage
        self.router = router
    }
    
    //MARK: - Input
    func fetchDids() {
        didCoreDataStorage?.fetchDids { [weak self] dids, error in
            guard let self = self else { return }
            if error == nil {
                self.fetchedDids = dids
                self.didsItem = dids.map { MainDidItemsViewModel($0) }
            } else {
                //TODO: Alert 사용해서 Core Data Fetch 실패를 알려야 하나
                #if DEBUG
                print("Error: \(String(describing: error))")
                #endif
            }
        }
    }
    //MARK: - Output
    private var fetchedDids: [Did]?
    @Published private var didsItem: [MainDidItemsViewModel] = []
    var didItemsPublisher: Published<[MainDidItemsViewModel]>.Publisher {
        $didsItem
    }
    
    func showCreateDid() {
        router?.showCreateDid()
    }
    
    func showCalendar() {
        guard let dids = fetchedDids else { return }
        router?.showCalendar(dids)
    }
}

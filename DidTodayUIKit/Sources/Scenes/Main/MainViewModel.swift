//
//  MainViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/15.
//

import Foundation

protocol MainViewModelInput {
    func fetchDids()
}

protocol MainViewModelOutput {
    var dids: [Did] { get }
}

final class MainViewModel: MainViewModelInput {
    var didcCoreDataStorage: DidCoreDataStorable?
    
    //MARK: - Input
    var fetchedDids = [Did]()
    
    func fetchDids() {
        didcCoreDataStorage?.fetchDids { [weak self] dids, error in
            if error == nil {
                self?.fetchedDids = dids
            } else {
                //TODO: Alert 사용해서 Core Data Fetch 실패를 알려야 하나
                #if DEBUG
                print("Error: \(String(describing: error))")
                #endif
            }
        }
    }
    //MARK: - Output
    var didItems: [MainDidItemsViewModel] {
        return fetchedDids.map { MainDidItemsViewModel($0)}
    }
}

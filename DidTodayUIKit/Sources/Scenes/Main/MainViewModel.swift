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
    var dids: [DidItem] { get }
}

final class MainViewModel: MainViewModelInput {
    var didcCoreDataStorage: DidCoreDataStorable?
    
    //MARK: - Input
    var fetchedDids = [DidItem]()
    
    func fetchDids() {
        didcCoreDataStorage?.fetchDids { [weak self] dids, error in
            if error == nil {
                self?.fetchedDids = dids
            } else {
                #if DEBUG
                print("Error: \(String(describing: error))")
                #endif
            }
        }
    }
    //MARK: - Output
}

//
//  SceneDIContainer.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/25.
//

import UIKit

final class SceneDIContainer: FlowCoordinatorDependenciesProtocol {
    
    //MARK: Core Data Storage
    let didCoreDataStorage = DidCoreDataStorage()
    //MARK: Main
    func makeMainViewController(router: MainRouter) -> UIViewController {
        let viewController = MainViewController.create(with: makeMainViewModel(router: router))
        return viewController
    }
    
    private func makeMainViewModel(router: MainRouter) -> MainViewModelProtocol {
        let viewModel = MainViewModel(didCoreDataStorage: didCoreDataStorage, router: router)
        return viewModel
    }
    
    //MARK: Calendar
    func makeCalendarViewController(dids: [Did]) -> UIViewController {
        let viewController = CalendarViewController.create(with: makeCalendarViewModel(by: dids))
        return viewController
    }
    
    private func makeCalendarViewModel(by dids: [Did]) -> CalendarViewModelProtocol {
        let viewModel = CalendarViewModel(dids: dids)
        return viewModel
    }
    
    //MARK: Create Did
    func makeCreateDidViewController() -> UIViewController {
        let viewController = CreateDidViewController.create(with: makeCreateDidViewModel())
        return viewController
    }
    
    private func makeCreateDidViewModel() -> CreateDidViewModelProtocol {
        let viewModel = CreateDidViewModel(didCoreDataStorage: didCoreDataStorage)
        return viewModel
    }
}

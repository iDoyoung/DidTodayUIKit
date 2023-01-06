//
//  SceneDIContainer.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/25.
//

import UIKit

protocol FlowCoordinatorDependenciesProtocol {
    func makeMainViewController(router: MainRouter) -> UIViewController
    func makeCalendarViewController(dids: [Did]) -> UIViewController
    func makeCreateDidViewController(startedDate: Date?, endedDate: Date?, fromDoing: Bool) -> UIViewController
    func makeDoingViewController(router: DoingRouter) -> UIViewController
    func makeInformationViewController() -> UIViewController
}

final class SceneDIContainer: FlowCoordinatorDependenciesProtocol {
    
    //MARK: Core Data Storage
    let didCoreDataStorage = DidCoreDataStorage()
    
    //MARK: Main VC
    func makeMainViewController(router: MainRouter) -> UIViewController {
        let viewController = MainViewController.create(with: makeMainViewModel(router: router))
        return viewController
    }
    
    private func makeMainViewModel(router: MainRouter) -> MainViewModelProtocol {
        let viewModel = MainViewModel(didCoreDataStorage: didCoreDataStorage, router: router)
        return viewModel
    }
    
    //MARK: Calendar VC
    func makeCalendarViewController(dids: [Did]) -> UIViewController {
        let viewController = CalendarViewController.create(with: makeCalendarViewModel(by: dids))
        return viewController
    }
    
    private func makeCalendarViewModel(by dids: [Did]) -> CalendarViewModelProtocol {
        let viewModel = CalendarViewModel(dids: dids)
        return viewModel
    }
    
    //MARK: Detail Day
    func makeDetailDayViewController(dids: [Did]) -> UIViewController {
        let viewController = DetailDayViewController.create(with: makeDetailDayViewModel(by: dids))
        return viewController
    }
    
    private func makeDetailDayViewModel(by dids: [Did]) -> DetailDayViewModelProtocol {
        let viewModel = DetailDayViewModel(dids: dids)
        return viewModel
    }
    
    //MARK: Create Did VC
    func makeCreateDidViewController(startedDate: Date?, endedDate: Date?, fromDoing: Bool) -> UIViewController {
        let viewController = CreateDidViewController.create(with: makeCreateDidViewModel(startedDate: startedDate, endedDate: endedDate, fromDoing: fromDoing))
        return viewController
    }
    
    private func makeCreateDidViewModel(startedDate: Date?, endedDate: Date?, fromDoing: Bool) -> CreateDidViewModelProtocol {
        let viewModel = CreateDidViewModel(didCoreDataStorage: didCoreDataStorage, startedDate: startedDate, endedDate: endedDate, fromDoing: fromDoing)
        return viewModel
    }
    
    //MARK: Doing VC
    func makeDoingViewController(router: DoingRouter) -> UIViewController {
        let viewController = DoingViewController.create(with: makeDoingViewModel(router: router))
        return viewController
    }
    
    private func makeDoingViewModel(router: DoingRouter) -> DoingViewModelProtocol {
        let viewModel = DoingViewModel(timerManager: TimerManager(), router: router)
        return viewModel
    }
    
    //MARK: Information VC
    func makeInformationViewController() -> UIViewController {
        let viewController = AboutViewController.create(with: makeInformationViewModel())
        return viewController
    }
    
    private func makeInformationViewModel() -> InformationViewModelProtocol {
        let viewModel = AboutViewModel()
        return viewModel
    }
}

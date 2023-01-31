//
//  SceneDIContainer.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/25.
//

import UIKit

protocol FlowCoordinatorDependenciesProtocol {
    func makeMainViewController(router: MainRouter) -> UIViewController
    func makeCalendarViewController(router: CalendarRouter) -> UIViewController
    func makeDetailDayViewController(selected: Date, dids: [Did]) -> UIViewController
    func makeCreateDidViewController(startedDate: Date?, endedDate: Date?, fromDoing: Bool) -> UIViewController
    func makeDoingViewController(router: DoingRouter) -> UIViewController
    func makeAboutViewController(router: AboutRouter) -> UIViewController
    func makePrivacyPolicyViewController() -> UIViewController
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
    func makeCalendarViewController(router: CalendarRouter) -> UIViewController {
        let viewController = CalendarViewController.create(with: makeCalendarViewModel(router: router))
        return viewController
    }
    
    private func makeCalendarViewModel(router: CalendarRouter) -> CalendarViewModelProtocol {
        let viewModel = CalendarViewModel(didCoreDataStorage: didCoreDataStorage, router: router)
        return viewModel
    }
    
    //MARK: Detail Day
    func makeDetailDayViewController(selected: Date, dids: [Did]) -> UIViewController {
        let viewController = DetailDayViewController.create(with: makeDetailDayViewModel(dids: dids, by: selected))
        return viewController
    }
    
    private func makeDetailDayViewModel(dids: [Did], by selected: Date) -> DetailDayViewModelProtocol {
        let viewModel = DetailDayViewModel(selected: selected, dids: dids)
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
        let viewModel = DoingViewModel(router: router)
        return viewModel
    }
    
    //MARK: Information VC
    func makeAboutViewController(router: AboutRouter) -> UIViewController {
        let viewController = AboutViewController.create(with: makeAboutViewModel(router: router))
        return viewController
    }
    
    private func makeAboutViewModel(router: AboutRouter) -> AboutViewModelProtocol {
        let viewModel = AboutViewModel(router: router)
        return viewModel
    }
    
    //MARK: Privacy Policy VC
    func makePrivacyPolicyViewController() -> UIViewController {
        let viewController = PrivacyPolicyViewController.create(with: makePrivacyPolicyViewModel())
        return viewController
    }
    
    private func makePrivacyPolicyViewModel() -> PrivacyPolicyViewModel {
        let viewModel = PrivacyPolicyViewModel()
        return viewModel
    }
}

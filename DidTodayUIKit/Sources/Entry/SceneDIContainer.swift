//
//  SceneDIContainer.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/25.
//

import UIKit

protocol FlowCoordinatorDependenciesProtocol {
    func makeTodayViewController(router: MainRouter) -> UIViewController
    func makeDidDetailsViewController(_ did: Did) -> UIViewController
    func makeCalendarViewController(router: CalendarRouter) -> UIViewController
    func makeDetailDayViewController(selected: Date, router: DetailDayRouter) -> UIViewController
    func makeCreateDidViewController(startedDate: Date?, endedDate: Date?, fromDoing: Bool) -> UIViewController
    func makeDoingViewController(router: DoingRouter) -> UIViewController
    func makeAboutViewController(router: AboutRouter) -> UIViewController
    func makePrivacyPolicyViewController() -> UIViewController
}

final class SceneDIContainer: FlowCoordinatorDependenciesProtocol {
    
    //MARK: Core Data Storage
    let didCoreDataStorage = DidCoreDataStorage()
    let reminderStore = ReminderStore()
    
    //MARK: Use Case
    //Did Use Case (Core Data)
    private var fetchDidUseCase: FetchDidUseCase {
        return DefaultFetchDidUseCase(storage: didCoreDataStorage)
    }
    
    private func makeFetchDidUseCase() -> FetchDidUseCase {
        return DefaultFetchDidUseCase(storage: didCoreDataStorage)
    }
    
    private func makeCreateDidUseCase() -> CreateDidUseCase {
        return DefaultCreateDidUseCase(storage: didCoreDataStorage)
    }
    
    private func makeDeleteDidUseCase() -> DeleteDidUseCase {
        return DefaultDeleteDidUseCase(storage: didCoreDataStorage)
    }
    
    //Reminder Use Case
    private var getRemindersAuthorizationStatusUseCase: GetRemindersAuthorizationStatusUseCaseProtocol {
        GetRemindersAuthorizationStatusUseCase(storage: reminderStore)
    }
    
    private var readReminderUseCase: ReadReminderUseCaseProtocol {
        ReadReminderUseCase(stroage: reminderStore)
    }
    
    private var requestAccessOfReminderUseCase: RequestAccessOfReminderUseCaseProtocol {
        RequestAccessOfReminderUseCase(stroage: reminderStore)
    }
    
    //MARK: Main VC
    func makeTodayViewController(router: MainRouter) -> UIViewController {
        let updater = TodayViewUpdater(interactor: makeTodayInteractor())
        let viewController = TodayViewController.create(with: updater)
        return viewController
    }
   
    private func makeTodayInteractor() -> TodayInteractor {
        return TodayInteractor(getRemindersAuthorizationStatusUseCase: getRemindersAuthorizationStatusUseCase,
                               requestAccessOfRemindersUseCase: requestAccessOfReminderUseCase,
                               readRemindersUseCase: readReminderUseCase,
                               fetchDidsUseCase: fetchDidUseCase)
    }
    
    //MARK: Did Details
    func makeDidDetailsViewController(_ did: Did) -> UIViewController {
        let viewController = DidDetailsViewController.create(with: makeDidDetailsViewModel(did))
        return viewController
    }
    
    private func makeDidDetailsViewModel(_ did: Did) -> DidDetailsViewModelProtocol {
        let viewModel = DidDetailsViewModel(did)
        viewModel.deleteDidUseCase = makeDeleteDidUseCase()
        return viewModel
    }
    
    //MARK: Calendar VC
    func makeCalendarViewController(router: CalendarRouter) -> UIViewController {
        let viewController = CalendarViewController.create(with: makeCalendarViewModel(router: router))
        return viewController
    }
    
    private func makeCalendarViewModel(router: CalendarRouter) -> CalendarViewModelProtocol {
        let viewModel = CalendarViewModel(fetchDidUseCase: makeFetchDidUseCase(), router: router)
        return viewModel
    }
    
    //MARK: Detail Day
    func makeDetailDayViewController(selected: Date, router: DetailDayRouter) -> UIViewController {
        let viewController = DetailDayViewController.create(with: makeDetailDayViewModel(by: selected, router: router))
        return viewController
    }
    
    private func makeDetailDayViewModel(by selected: Date, router: DetailDayRouter) -> DetailDayViewModelProtocol {
        let viewModel = DetailDayViewModel(selected: selected)
        viewModel.fetchDidUseCase = makeFetchDidUseCase()
        viewModel.router = router
        return viewModel
    }
    
    //MARK: Create Did VC
    func makeCreateDidViewController(startedDate: Date?, endedDate: Date?, fromDoing: Bool) -> UIViewController {
        let viewController = CreateDidViewController.create(with: makeCreateDidViewModel(startedDate: startedDate, endedDate: endedDate, fromDoing: fromDoing))
        return viewController
    }
    
    private func makeCreateDidViewModel(startedDate: Date?, endedDate: Date?, fromDoing: Bool) -> CreateDidViewModelProtocol {
        let viewModel = CreateDidViewModel(createDidUseCase: makeCreateDidUseCase(), startedDate: startedDate, endedDate: endedDate, fromDoing: fromDoing)
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

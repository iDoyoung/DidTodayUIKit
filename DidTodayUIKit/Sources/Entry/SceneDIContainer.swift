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
    func makeMainViewController() -> UIViewController {
        let viewController = MainViewController.create(with: makeMainViewModel())
        return viewController
    }
    
    func makeMainViewModel() -> MainViewModelProtocol {
        let viewModel = MainViewModel(didCoreDataStorage: didCoreDataStorage)
        return viewModel
    }
    
    //MARK: Calendar
    func makeCalendarViewController() -> UIViewController {
        let viewController = CalendarViewController()
        return viewController
    }
    
    //MARK: Create Did
    func makeCreateDidViewController() -> UIViewController {
        let viewController = CreateDidViewController.create(with: makeCreateDidViewModel())
        return viewController
    }
    
    func makeCreateDidViewModel() -> CreateDidViewModelProtocol {
        let viewModel = CreateDidViewModel(didCoreDataStorage: didCoreDataStorage)
        return viewModel
    }
}

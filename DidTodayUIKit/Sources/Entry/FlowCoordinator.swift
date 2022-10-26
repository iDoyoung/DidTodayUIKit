//
//  FlowCoordinator.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/25.
//

import UIKit

protocol FlowCoordinatorDependenciesProtocol {
    func makeMainViewController() -> UIViewController
    func makeCalendarViewController() -> UIViewController
    func makeCreateDidViewController() -> UIViewController
}

final class FlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: FlowCoordinatorDependenciesProtocol
    
    init(navigationController: UINavigationController,
         dependencies: FlowCoordinatorDependenciesProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showMain()
    }
    
    private func showMain() {
        let viewController = dependencies.makeMainViewController()
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func showCalendar() {
        let viewController = dependencies.makeCalendarViewController()
        navigationController?.present(viewController, animated: true)
    }
    
    private func showCreateDid() {
        let viewController = dependencies.makeCreateDidViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
//
//  FlowCoordinator.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/25.
//

import UIKit

final class MainFlowCoordinator: Coordinator {
    
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
        let router = MainRouter(showCalendar: showCalendarCoordinator,
                                showCreateDid: showCreateDid,
                                showDoing: showDoingCoordinator,
                                showInformation: showAboutCoordinator)
        let viewController = dependencies.makeMainViewController(router: router)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func showCreateDid(startedDate: Date? = nil, endedDate: Date? = nil) {
        let viewController = UINavigationController(rootViewController: dependencies.makeCreateDidViewController(startedDate: startedDate, endedDate: endedDate, fromDoing: false))
        viewController.navigationBar.tintColor = .label
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    private func showCalendarCoordinator() {
        let viewController = UINavigationController()
        let coordinator = CalendarFlowCoordinator(navigationController: viewController, dependencies: dependencies)
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true)
        coordinator.start()
    }
    
    private func showDoingCoordinator() {
        let viewController = UINavigationController()
        let coordinator = DoingFlowCoordinator(navigationController: viewController, dependencies: dependencies)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
        coordinator.start()
    }
    
    private func showAboutCoordinator() {
        let viewController = UINavigationController()
        let coordinator = AboutFlowCoordinator(navigationController: viewController, dependencies: dependencies)
        navigationController?.present(viewController, animated: true)
        coordinator.start()
    }
}

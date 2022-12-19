//
//  FlowCoordinator.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/25.
//

import UIKit

protocol FlowCoordinatorDependenciesProtocol {
    func makeMainViewController(router: MainRouter) -> UIViewController
    func makeCalendarViewController(dids: [Did]) -> UIViewController
    func makeCreateDidViewController(startedDate: Date?, endedDate: Date?) -> UIViewController
    func makeDoingViewController(router: DoingRouter) -> UIViewController
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
        let router = MainRouter(showCalendar: showCalendar,
                                showCreateDid: showCreateDid,
                                showDoing: showDoing)
        let viewController = dependencies.makeMainViewController(router: router)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func showCalendar(dids: [Did]) {
        let viewController = dependencies.makeCalendarViewController(dids: dids)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    private func showCreateDid(startedDate: Date? = nil, endedDate: Date? = nil) {
        let viewController = UINavigationController(rootViewController: dependencies.makeCreateDidViewController(startedDate: startedDate, endedDate: endedDate))
        viewController.navigationBar.tintColor = .label
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    private func showDoing() {
        let router = DoingRouter(showCreateDid: showCreateDid(startedDate:endedDate:))
        let viewController = dependencies.makeDoingViewController(router: router)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
}

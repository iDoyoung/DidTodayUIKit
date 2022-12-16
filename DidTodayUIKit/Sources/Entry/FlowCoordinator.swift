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
    func makeCreateDidViewController() -> UIViewController
    func makeDoingViewController() -> UIViewController
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
        let router = MainRouter(showCalendar: showCalendar,
                                showCreateDid: showCreateDid,
                                showDoing: showDoing)
        showMain(router: router)
    }
    
    private func showMain(router: MainRouter) {
        let viewController = dependencies.makeMainViewController(router: router)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func showCalendar(dids: [Did]) {
        let viewController = dependencies.makeCalendarViewController(dids: dids)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    private func showCreateDid() {
        let viewController = UINavigationController(rootViewController: dependencies.makeCreateDidViewController())
        viewController.navigationBar.tintColor = .label
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    private func showDoing() {
        let viewController = dependencies.makeDoingViewController()
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
}

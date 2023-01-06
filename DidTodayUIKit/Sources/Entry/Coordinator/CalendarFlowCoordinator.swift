//
//  CalendarFlowCoordinator.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/06.
//

import UIKit

final class CalendarFlowCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: FlowCoordinatorDependenciesProtocol

    init(navigationController: UINavigationController?, dependencies: FlowCoordinatorDependenciesProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        showCalendar()
    }
    
    private func showCalendar() {
        let router = CalendarRouter(showDetailDay: showDetailDay)
        let viewController = UINavigationController(rootViewController: dependencies.makeCalendarViewController(router: router))
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: false)
    }

    private func showDetailDay(dids: [Did]) {
        let viewController = dependencies.makeDetailDayViewController(dids: dids)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

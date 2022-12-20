//
//  DoingFlowCoordinator.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/20.
//

import UIKit

protocol DoingFlowCoordinatorDependenciesProtocol {
    func makeDoingViewController(router: DoingRouter) -> UIViewController
    func makeCreateDidViewController(startedDate: Date?, endedDate: Date?) -> UIViewController
}

final class DoingFlowCoordinator: Coordinator {
    
    
    var children = [Coordinator]()
    private weak var navigationConroller: UINavigationController?
    private let dependencies: DoingFlowCoordinatorDependenciesProtocol
    //private let dependencies
    
    init(navigationConroller: UINavigationController? = nil, dependencies: DoingFlowCoordinatorDependenciesProtocol) {
        self.navigationConroller = navigationConroller
        self.dependencies = dependencies
    }
    
    func start() {
        
    }
    
    private func showDoing() {
        
    }
    
    private func showCreateDid(startedDate: Date?, endedDate: Date?) {
        let viewController = UINavigationController(rootViewController: dependencies.makeCreateDidViewController(startedDate: startedDate, endedDate: endedDate))
        navigationConroller?.pushViewController(viewController, animated: true)
    }
}

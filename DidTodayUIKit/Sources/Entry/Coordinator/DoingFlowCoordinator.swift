////
////  DoingFlowCoordinator.swift
////  DidTodayUIKit
////
////  Created by Doyoung on 2022/12/20.
////
//
//import UIKit
//
//final class DoingFlowCoordinator: Coordinator {
//    
//    private weak var navigationController: UINavigationController?
//    private let dependencies: FlowCoordinatorDependenciesProtocol
//    
//    init(navigationController: UINavigationController?, dependencies: FlowCoordinatorDependenciesProtocol) {
//        self.navigationController = navigationController
//        self.dependencies = dependencies
//    }
//    
//    func start() {
//        showDoing()
//    }
//    
//    private func showDoing() {
//        let router = DoingRouter(showCreateDid: showCreateDid(startedDate:endedDate:))
//        let viewController = dependencies.makeDoingViewController(router: router)
//        navigationController?.pushViewController(viewController, animated: false)
//    }
//    
//    private func showCreateDid(startedDate: Date?, endedDate: Date?) {
////        let viewController = dependencies.makeCreateDidViewController(router: <#CreateDidRouter#>, startedDate: startedDate, endedDate: endedDate, fromDoing: true)
////        navigationController?.pushViewController(viewController, animated: true)
//    }
//    
//    deinit {
//        #if DEBUG
//        print("Deinit Doing Flow Coordinator)")
//        #endif
//    }
//}

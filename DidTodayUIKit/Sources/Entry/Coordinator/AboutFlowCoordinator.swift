//
//  AboutFlowCoordinator.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/17.
//

import UIKit

final class AboutFlowCoordinator: Coordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: FlowCoordinatorDependenciesProtocol
    
    init(navigationController: UINavigationController?, dependencies: FlowCoordinatorDependenciesProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        showAbout()
    }
    
    private func showAbout() {
        let router = AboutRouter(showActivityToRecommend: showActivityViewControllerToRecommend, openAppStoreToReview: openAppStoreToWriteAReview, showPrivacyPolicy: showPrivacyPolicy)
        let viewController = dependencies.makeAboutViewController(router: router)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func showActivityViewControllerToRecommend(with message: [String]) {
        let activityVC = UIActivityViewController(activityItems: message, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = navigationController?.view
                popover.sourceRect = navigationController?.accessibilityFrame ?? CGRect()
            }
        }
        navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
    private func openAppStoreToWriteAReview() {
        
    }
    
    private func showPrivacyPolicy() {
        let viewController = dependencies.makePrivacyPolicyViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

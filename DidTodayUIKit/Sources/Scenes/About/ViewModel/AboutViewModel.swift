//
//  InformationViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/22.
//

import UIKit

protocol AboutViewModelProtocol: AboutViewModelInput, AboutViewModelOuput {   }

protocol AboutViewModelInput {
    func select(_ index: Int)
}

protocol AboutViewModelOuput {
    var about: AboutDid { get }
}

final class AboutViewModel: AboutViewModelProtocol {
    
    enum Link: Int, CaseIterable {
        case recommend
        case review
        case privacyPolicy
        
        var text: String {
            switch self {
            case .recommend:
                return CustomText.recommendDid
            case .review:
                return CustomText.writeAReview
            case .privacyPolicy:
                return CustomText.privacyPolicy
            }
        }
    }
    
    private var router: AboutRouter?
    
    init(router: AboutRouter) {
        self.router = router
    }
    
    //MARK: - Input
    func select(_ index: Int) {
        guard let list = Link(rawValue: index) else { return }
        switch list {
        case .recommend:
            showActivityToRecommend()
        case .review:
            openAppStoreToReview()
        case .privacyPolicy:
            showPrivacyPolicy()
        }
    }
    
    //MARK: - Output
    let about = AboutDid()
    
    private func showActivityToRecommend() {
        router?.showActivityToRecommend(["https://apps.apple.com/app/id1549357218"])
    }
    
    private func openAppStoreToReview() {
        router?.openAppStoreToReview()
    }
    
    private func showPrivacyPolicy() {
        router?.showPrivacyPolicy()
    }
}

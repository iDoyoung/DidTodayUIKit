//
//  InformationViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/22.
//

import UIKit

protocol AboutViewModelProtocol: AboutViewModelInput, AboutViewModelOutput {   }

protocol AboutViewModelInput {
    func select(_ index: Int)
}

protocol AboutViewModelOutput {
    var about: AboutDid { get }
}

final class AboutViewModel: AboutViewModelProtocol {
    
    ///Link to move new page
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
    
    //MARK: - Properties
    
    //MARK: - Output
    let about = AboutDid()
    
    private var router: AboutRouter?
    
    //MARK: - Methods
    init(router: AboutRouter) {
        self.router = router
    }
    
    //MARK: Input
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
    
    private func showActivityToRecommend() {
        router?.showActivityToRecommend(["https://apps.apple.com/app/id1549357218"])
    }
    
    private func openAppStoreToReview() {
        router?.openAppStoreToReview()
    }
    
    private func showPrivacyPolicy() {
        router?.showPrivacyPolicy()
    }
    
    deinit {
        #if DEBUG
        print("Deinit About View Model")
        #endif
    }
}

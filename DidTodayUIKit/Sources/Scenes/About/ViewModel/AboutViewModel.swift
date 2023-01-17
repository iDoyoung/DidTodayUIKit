//
//  InformationViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/22.
//

import Foundation
import UIKit

protocol AboutViewModelProtocol: AboutViewModelInput, AboutViewModelOuput {   }

protocol AboutViewModelInput {
}

protocol AboutViewModelOuput {
    var about: AboutDid { get }
    var items: [AboutItem] { get }
}

final class AboutViewModel: AboutViewModelProtocol {
    
    private var router: AboutRouter?
    let about = AboutDid()
    let items = [AboutItem(title: CustomText.recommendDid),
                 AboutItem(title: CustomText.writeAReview),
                 AboutItem(title: CustomText.privacyPolicy)]
    
    init(router: AboutRouter) {
        self.router = router
    }
}

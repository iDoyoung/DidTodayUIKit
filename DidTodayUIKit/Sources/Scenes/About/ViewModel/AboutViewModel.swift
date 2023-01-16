//
//  InformationViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/22.
//

import Foundation

protocol InformationViewModelProtocol: InformationViewModelInput, InformationViewModelOuput {   }

protocol InformationViewModelInput {
}

protocol InformationViewModelOuput {
    var about: AboutDid { get }
    var items: [AboutItem] { get }
}

final class AboutViewModel: InformationViewModelProtocol {
    let about = AboutDid()
    let items = [AboutItem(title: CustomText.recommendDid),
                 AboutItem(title: CustomText.writeAReview),
                 AboutItem(title: CustomText.privacyPolicy)]
}

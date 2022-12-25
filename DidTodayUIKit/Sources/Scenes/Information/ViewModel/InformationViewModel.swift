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

final class InformationViewModel: InformationViewModelProtocol {
    let about = AboutDid()
    let items = [AboutItem(title: "Recommend Did"),
                 AboutItem(title: "Write a review"),
                 AboutItem(title: "Privacy Policy")]
}

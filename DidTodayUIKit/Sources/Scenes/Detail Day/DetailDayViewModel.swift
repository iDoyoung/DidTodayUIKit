//
//  DetailDayViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/06.
//

import Foundation

protocol DetailDayViewModelProtocol: DetailDayViewModelInput, DetailDayViewModelOutput {  }

protocol DetailDayViewModelInput {
    
}

protocol DetailDayViewModelOutput {
    
}

final class DetailDayViewModel: DetailDayViewModelProtocol {
    
    init(dids: [Did]) {
    }
}

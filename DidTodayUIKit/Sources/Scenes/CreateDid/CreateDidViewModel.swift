//
//  CreateDidViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/19.
//

import UIKit

protocol CreateDidViewModelInput {
    var startedTime: Date? { get set }
    var endedTime: Date? { get set }
    var color: UIColor? { get set }
    var title: String? { get set }
}

protocol CreateDidViewModelOutput {
    var titlePublisher: Published<String?>.Publisher { get }
}

final class CreateDidViewModel: CreateDidViewModelInput, CreateDidViewModelOutput {
    //MARK: - Input
    var startedTime: Date?
    var endedTime: Date?
    var color: UIColor?
    @Published var title: String?
    
    func createDid() {
    }
    
    //MARK: - Output
    var titlePublisher: Published<String?>.Publisher { $title }
}

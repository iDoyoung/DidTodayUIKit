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
    var startedTimePublished: Published<Date?>.Publisher { get }
    var endedTimePublished: Published<Date?>.Publisher { get }
    var colorPublished: Published<UIColor?>.Publisher { get }
    var titlePublisher: Published<String?>.Publisher { get }
}

final class CreateDidViewModel: CreateDidViewModelInput, CreateDidViewModelOutput {
    //MARK: - Input
    @Published var startedTime: Date?
    @Published var endedTime: Date?
    @Published var color: UIColor?
    @Published var title: String?
    
    func createDid() {
    }
    
    //MARK: - Output
    var startedTimePublished: Published<Date?>.Publisher { $startedTime }
    var endedTimePublished: Published<Date?>.Publisher { $endedTime }
    var colorPublished: Published<UIColor?>.Publisher { $color }
    var titlePublisher: Published<String?>.Publisher { $title }
}

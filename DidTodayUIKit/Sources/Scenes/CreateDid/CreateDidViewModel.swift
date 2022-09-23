//
//  CreateDidViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/19.
//

import UIKit

enum CreateDidError: Error {
    case startedTimeError
    case coreDataError(CoreDataStoreError)
}

protocol CreateDidViewModelInput {
    var startedTime: Date? { get set }
    var endedTime: Date? { get set }
    var color: UIColor? { get set }
    var title: String? { get set }
    
    func createDid(completion: @escaping (Result<Did, CreateDidError>) -> Void)
}

protocol CreateDidViewModelOutput {
    var startedTimePublished: Published<Date?>.Publisher { get }
    var endedTimePublished: Published<Date?>.Publisher { get }
    var colorPublished: Published<UIColor?>.Publisher { get }
    var titlePublisher: Published<String?>.Publisher { get }
}

final class CreateDidViewModel: CreateDidViewModelInput, CreateDidViewModelOutput {
    var didCoreDataStorage: DidCoreDataStorable?
    
    init(didCoreDataStorage: DidCoreDataStorable) {
        self.didCoreDataStorage = didCoreDataStorage
    }
    
    //MARK: - Input
    @Published var startedTime: Date? = Date()
    @Published var endedTime: Date? = Date()
    @Published var color: UIColor?
    @Published var title: String?
    
    func createDid(completion: @escaping (Result<Did, CreateDidError>) -> Void) {
        guard let startedTime = startedTime,
              let endedTime = endedTime,
              let title = title,
              let color = color?.cgColor.components else {
            completion(.failure(CreateDidError.startedTimeError))
            return
        }
        let pieColor = Did.PieColor(red: Float(color[0]),
                                    green: Float(color[1]),
                                    blue: Float(color[2]),
                                    alpha: Float(color[3]))
        let did = Did(enforced: true,
                      started: startedTime,
                      finished: endedTime,
                      content: title,
                      color: pieColor)
        didCoreDataStorage?.create(did) { did, error in
            if let error = error {
                completion(.failure(CreateDidError.coreDataError(error)))
            } else {
                completion(.success(did))
            }
        }
    }
    
    //MARK: - Output
    var startedTimePublished: Published<Date?>.Publisher { $startedTime }
    var endedTimePublished: Published<Date?>.Publisher { $endedTime }
    var colorPublished: Published<UIColor?>.Publisher { $color }
    var titlePublisher: Published<String?>.Publisher { $title }
}

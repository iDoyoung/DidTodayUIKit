//
//  CreateDidViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/19.
//

import UIKit
import Combine

enum CreateDidError: Error {
    case startedTimeError
    case coreDataError(CoreDataStoreError)
}

protocol CreateDidViewModelProtocol: CreateDidViewModelInput, CreateDidViewModelOutput {    }

protocol CreateDidViewModelInput {
    func setTitle(_ title: String)
    func setStartedTime(_ date: Date)
    func setEndedTime(_ date: Date)
    func setColorOfPie(_ color: UIColor)
    
    func createDid(completion: @escaping (Result<Did, CreateDidError>) -> Void)
}

protocol CreateDidViewModelOutput {
    var titleOfDid: CurrentValueSubject<String?, Never> { get }
    var colorOfPie: CurrentValueSubject<UIColor, Never> { get }
    var startedTime: PassthroughSubject<Date, Never> { get }
    var endedTime: PassthroughSubject<Date, Never> { get }
}

final class CreateDidViewModel: CreateDidViewModelProtocol {
   
    var didCoreDataStorage: DidCoreDataStorable?
    
    init(didCoreDataStorage: DidCoreDataStorable) {
        self.didCoreDataStorage = didCoreDataStorage
    }
    
    //MARK: - Input
    func setTitle(_ title: String) {
        titleOfDid.send(title)
    }
    
    func setStartedTime(_ date: Date) {
        startedTime.send(date)
    }
    
    func setEndedTime(_ date: Date) {
        endedTime.send(date)
    }
     
    func setColorOfPie(_ color: UIColor) {
        colorOfPie.send(color)
    }
    
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
    var titleOfDid = CurrentValueSubject<String?, Never>(nil)
    var startedTime = PassthroughSubject<Date, Never>()
    var endedTime = PassthroughSubject<Date, Never>()
    var colorOfPie = CurrentValueSubject<UIColor, Never>(.customGreen)
}

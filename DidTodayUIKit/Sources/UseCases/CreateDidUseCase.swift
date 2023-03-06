//
//  CreateDidUseCase.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/05.
//

import Foundation

protocol CreateDidUseCase {
    @discardableResult func execute(_ did: Did) async throws -> Did
}

final class DefaultCreateDidUseCase: CreateDidUseCase {
    
    private let storage: DidCoreDataStorable
    
    init(storage: DidCoreDataStorable) {
        self.storage = storage
    }
    
    func execute(_ did: Did) async throws -> Did {
        try await storage.create(did)
    }
}

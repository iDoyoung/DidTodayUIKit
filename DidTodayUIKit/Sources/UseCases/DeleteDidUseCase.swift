//
//  DeleteDidUseCase.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/13.
//

import Foundation

protocol DeleteDidUseCase {
    @discardableResult func execute(with did: Did) async throws -> Did
}

final class DefaultDeleteDidUseCase: DeleteDidUseCase {
    
    private let storage: DidCoreDataStorable
    
    init(storage: DidCoreDataStorable) {
        self.storage = storage
    }
    
    @discardableResult func execute(with did: Did) async throws -> Did {
        try await storage.delete(did)
    }
}

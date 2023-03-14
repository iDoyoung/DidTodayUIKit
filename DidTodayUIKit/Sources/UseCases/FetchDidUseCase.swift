//
//  DidUseCase.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/04.
//

import Foundation

protocol FetchDidUseCase {
    func execute() async throws -> [Did]
    func executeFilteredByToday() async throws -> [Did]
    func executeFiltered(by date: Date) async throws -> [Did]
}

final class DefaultFetchDidUseCase: FetchDidUseCase {
    
    private let storage: DidCoreDataStorable
    
    init(storage: DidCoreDataStorable) {
        self.storage = storage
    }
    
    func execute() async throws -> [Did] {
        try await storage.fetchDids(with: nil)
    }
    
    func executeFilteredByToday() async throws -> [Did] {
        try await storage.fetchDids(with: Date())
    }
    
    func executeFiltered(by date: Date) async throws -> [Did] {
        try await storage.fetchDids(with: date)
    }
}

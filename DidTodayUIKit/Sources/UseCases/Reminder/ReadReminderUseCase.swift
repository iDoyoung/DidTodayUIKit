//
//  ReadReminderUseCase.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 3/12/24.
//

import Foundation

protocol ReadReminderUseCaseProtocol {
    func execute() async throws -> [Reminder]
}

final class ReadReminderUseCase: ReadReminderUseCaseProtocol {
    
    private let stroage: ReminderStoreProtocol
    
    init(stroage: ReminderStoreProtocol) {
        self.stroage = stroage
    }
    
    func execute() async throws -> [Reminder] {
        try await stroage.readAll()
    }
}

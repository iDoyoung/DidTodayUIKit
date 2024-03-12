//
//  ReadReminderUseCase.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 3/12/24.
//

import Foundation

protocol ReadReminderUseCaseProtocol {
    func excute() async throws -> [Reminder]
}

final class ReadReminderUseCase: ReadReminderUseCaseProtocol {
    
    private let stroage: ReminderStoreProtocol
    
    init(stroage: ReminderStoreProtocol) {
        self.stroage = stroage
    }
    
    func excute() async throws -> [Reminder] {
        try await stroage.readAll()
    }
}

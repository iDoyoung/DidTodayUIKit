//
//  ReadReminderUseCaseTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 3/12/24.
//

import XCTest
@testable import DidTodayUIKit

final class ReadReminderUseCaseTests: XCTestCase {
    
    // MARK: - System under tests
    var sut: ReadReminderUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        reminderStoreSpy = ReminderStoreSpy()
        sut = ReadReminderUseCase(stroage: reminderStoreSpy!)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    // MARK: - Test Doubles
    var reminderStoreSpy: ReminderStoreSpy!
    
    final class ReminderStoreSpy: ReminderStoreProtocol {
        
        var isAvailable: Bool = false
        
        var requestAccessCalled = false
        var readAllCalled = false
        
        func requestAccess() async throws {
            requestAccessCalled = true
        }
        
        func readAll() async throws -> [DidTodayUIKit.Reminder] {
            readAllCalled = true
            return []
        }
    }
    
    // MARK: - Tests
    func test_reminderUseCase_shouldCallReadAllAndReadedBeEmpty() async throws {
        let readed = try await sut.excute()
        XCTAssertTrue(reminderStoreSpy!.readAllCalled)
        XCTAssertTrue(readed.isEmpty)
    }
}

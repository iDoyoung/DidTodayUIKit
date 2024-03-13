//
//  RequestAccessOfReminderUseCaseTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 3/12/24.
//

import XCTest
@testable import DidTodayUIKit

final class RequestAccessOfReminderUseCaseTests: XCTestCase {

    // MARK: - System under tests
    var sut: RequestAccessOfReminderUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        reminderStoreSpy = ReminderStoreSpy()
        sut = RequestAccessOfReminderUseCase(stroage: reminderStoreSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        reminderStoreSpy = nil
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
    func test_requestAccess_shouldCallRequestAccess() async throws {
        try await sut.excute()
        XCTAssertTrue(reminderStoreSpy!.requestAccessCalled)
    }
}

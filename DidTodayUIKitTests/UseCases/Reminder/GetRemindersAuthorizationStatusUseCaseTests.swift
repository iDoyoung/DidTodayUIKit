import XCTest
@testable import DidTodayUIKit

class GetRemindersAuthorizationStatusUseCaseTests: XCTestCase {
    
    //MARK: System Under Test
    var sut: GetRemindersAuthorizationStatusUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        reminderStoreSpy = ReminderStoreSpy()
        sut = GetRemindersAuthorizationStatusUseCase(storage: reminderStoreSpy)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        reminderStoreSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: Tests
    
    func test_execute_shouldCallReminderStoreAndBeAvailable() async throws {
        
        //given
        reminderStoreSpy.isAvailable = true
        
        //when
        let isAvailable = try await sut.execute()
        
        //then
        XCTAssertTrue(isAvailable)
        XCTAssertTrue(reminderStoreSpy.isCalled)
    }
    
    //MARK: Test Doubles
    
    var reminderStoreSpy: ReminderStoreSpy!
    
    final class ReminderStoreSpy: ReminderStoreProtocol {
        var isCalled = false
        var isAvailable: Bool {
            get {
                isCalled
            }
            set {
                isCalled = newValue
            }
        }
        
        func requestAccess() async throws { 
        }
        func readAll() async throws -> [DidTodayUIKit.Reminder] {
            return []
        }
    }
}

import XCTest
@testable import DidTodayUIKit

final class TodayInteractorTests: XCTestCase {

    var sut: TodayInteractor!
    
    override func setUpWithError() throws {
       try super.setUpWithError()
        readReminderUseCaseSpy = ReadReminderUseCaseSpy()
        requestAccessRemindersUseCaseSpy = RequestAccessRemindersUseCaseSpy()
        fetchDidsUseCaseSpy = FetchDidsUseCaseSpy()
        
        sut = TodayInteractor(
            requestAccessOfRemindersUseCase: requestAccessRemindersUseCaseSpy,
            readRemindersUseCase: readReminderUseCaseSpy,
            fetchDidsUseCase: fetchDidsUseCaseSpy
        )
    }

    override func tearDownWithError() throws {
        sut = nil
        readReminderUseCaseSpy = nil
        requestAccessRemindersUseCaseSpy = nil
        fetchDidsUseCaseSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: Tests
    func test_whenExecuteReadRemindersUseCase_shouldCallReadReminderUseCaseAndSetReminderToViewModel() async throws {
        var mockTodayViewModel = TodayViewModel(reminders: [Reminder(title: "Mock",
                                                                     dueDate: Date())])
        try await sut.execute(useCase: .readReminders,
                              viewModel: &mockTodayViewModel)
        
        XCTAssertTrue(readReminderUseCaseSpy.called)
        XCTAssertEqual(mockTodayViewModel.reminders,
                       readReminderUseCaseSpy.reminders)
    }
    
    func test_whenExecuteRequestUseCase_shouldCallRequestAccessOfReminders() async throws {
        var mockTodayViewModel = TodayViewModel()
        try await sut.execute(useCase: .requestAccessOfReminders,
                              viewModel: &mockTodayViewModel)
        XCTAssertTrue(true)
    }
    
    //MARK: Test Doubles
    
    var requestAccessRemindersUseCaseSpy: RequestAccessRemindersUseCaseSpy!
    var readReminderUseCaseSpy: ReadReminderUseCaseSpy!
    var fetchDidsUseCaseSpy: FetchDidsUseCaseSpy!
    
    class RequestAccessRemindersUseCaseSpy: RequestAccessOfReminderUseCaseProtocol {
        
        var called = false
        
        func excute() async throws {
            called = true
        }
    }
    
    class ReadReminderUseCaseSpy: ReadReminderUseCaseProtocol {
        
        var called = false
        var reminders = [Reminder]()
        
        func excute() async throws -> [DidTodayUIKit.Reminder] {
            called = true
            return reminders
        }
    }
    
    class FetchDidsUseCaseSpy: FetchDidUseCase {
        
        var called = false
        var dids = [Did]()
        
        func execute() async throws -> [DidTodayUIKit.Did] {
            called = true
            return dids
        }
        
        func executeFilteredByToday() async throws -> [DidTodayUIKit.Did] {
            called = true
            return dids
        }
        
        func executeFiltered(by date: Date) async throws -> [DidTodayUIKit.Did] {
            called = true
            return dids
        }
    }
}

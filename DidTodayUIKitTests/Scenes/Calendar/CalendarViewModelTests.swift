//
//  CalendarViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/02/23.
//

import XCTest
import Combine
@testable import DidTodayUIKit

final class CalendarViewModelTests: XCTestCase {

    var sut: CalendarViewModel!
    var coordinatorSpy: CoordinatorSpy!
    var mockDids = [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
    
    private var cancellableBag = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        fetchDidUseCaseSpy = FetchDidUseCaseSpy()
        coordinatorSpy = CoordinatorSpy()
        let router = CalendarRouter(showDetailDay: coordinatorSpy.showDetail(date:dids:))
        sut = CalendarViewModel(fetchDidUseCase: fetchDidUseCaseSpy, router: router)
    }

    override func tearDownWithError() throws {
        sut = nil
        fetchDidUseCaseSpy = nil
        coordinatorSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    var fetchDidUseCaseSpy: FetchDidUseCaseSpy!
    
    final class FetchDidUseCaseSpy: FetchDidUseCase {
        
        @Published var isExecuted = false
        
        func execute() async throws -> [DidTodayUIKit.Did] {
            isExecuted = true
            return [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
        }
        
        func executeFiltered(by date: Date) async throws -> [DidTodayUIKit.Did] {
            return []
        }
        
        func executeFilteredByToday() async throws -> [DidTodayUIKit.Did] {
            return []
        }
    }
    
    class CoordinatorSpy {
        
        var showDetailCalled = false
        
        func showDetail(date: Date, dids: [Did]) {
            showDetailCalled = true
        }
    }
    
    //MARK: - Tests
    func test_fetchDids_shouldCallStorage() {
        let promise = expectation(description: "Storage Be Called")
        fetchDidUseCaseSpy.$isExecuted
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        
        sut.fetchDids()
        wait(for: [promise], timeout: 2)
        
        XCTAssertTrue(fetchDidUseCaseSpy.isExecuted)
    }
    
    func test_fetchDids_shouldSendDateOfDidsWhenHaveDidsAndStartedDataHasValue() {
        let promise = expectation(description: "Should send value")
        sut.dateOfDids
            .sink { dates in
                if !dates.isEmpty {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        sut.fetchDids()
        wait(for: [promise], timeout: 2)
        
        let expectation = mockDids.map { $0.started.omittedTime() }
        XCTAssertEqual(sut.dateOfDids.value, expectation)
        XCTAssertNotNil(sut.startedDate)
    }
    
    func test_showDetail_shouldCallCoordinator_whenSelectedDay() {
        sut.selectedDay = DateComponents()
        sut.showDetail()
        XCTAssert(coordinatorSpy.showDetailCalled)
    }
}

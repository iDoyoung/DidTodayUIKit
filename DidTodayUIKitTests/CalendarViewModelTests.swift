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
    var didsCoreDataStorageSpy: DidsCoreDataStorageSpy!
    var coordinatorSpy: CoordinatorSpy!
    var mockDids = [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
    
    private var cancellableBag = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        didsCoreDataStorageSpy = DidsCoreDataStorageSpy()
        coordinatorSpy = CoordinatorSpy()
        let router = CalendarRouter(showDetailDay: coordinatorSpy.showDetail(date:dids:))
        sut = CalendarViewModel(didCoreDataStorage: didsCoreDataStorageSpy, router: router)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    final class DidsCoreDataStorageSpy: DidCoreDataStorable {
        
        var dids: [Did]!
        var createDidCalled = false
        @Published var fetchDidsCalled = false
        var updateDidCalled = false
        var deleteDidCalled = false
        
        func create(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            createDidCalled = true
        }
        
        func fetchDids() async throws -> [DidTodayUIKit.Did] {
            fetchDidsCalled = true
            dids = [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
            return dids
        }
        
        func update(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            updateDidCalled = true
        }
        
        func delete(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            deleteDidCalled = true
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
        didsCoreDataStorageSpy.$fetchDidsCalled
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        
        sut.fetchDids()
        wait(for: [promise], timeout: 2)
        
        XCTAssertTrue(didsCoreDataStorageSpy.fetchDidsCalled)
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

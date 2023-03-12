//
//  MainViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/15.
//

import XCTest
import Combine
@testable import DidTodayUIKit

class MainViewModelTests: XCTestCase {
    //MARK: - System Under Test
    var sut: MainViewModel!
    var coordinatorSpy: CoordinatorSpy!
    var mockDids = [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
    private var cancellableBag = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        fetchDidUseCaseSpy = FetchDidUseCaseSpy()
        coordinatorSpy = CoordinatorSpy()
        let router = MainRouter(showCalendar: coordinatorSpy.showCalendar,
                                showCreateDid: coordinatorSpy.showCreateDid(started:ended:),
                                showDoing: coordinatorSpy.showDoing,
                                showInformation: coordinatorSpy.showInformation,
                                showDidDetails: coordinatorSpy.showDidDetails)
        sut = MainViewModel(fetchDidUseCase: fetchDidUseCaseSpy, router: router)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        fetchDidUseCaseSpy = nil
        coordinatorSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    var fetchDidUseCaseSpy: FetchDidUseCaseSpy!
    
    class CoordinatorSpy {
        
        var showDidDetails = false
        var showCalendarCalled = false
        var showCreateDidCalled = false
        var showDoingCalled = false
        var showInformationCalled = false
        
        func showDidDetails(_ did: Did) {
            showDidDetails = true
        }
        
        func showCalendar() {
            showCalendarCalled = true
        }
        
        func showCreateDid(started: Date?, ended: Date?) {
            showCreateDidCalled = true
        }
        
        func showDoing() {
            showDoingCalled = true
        }
        
        func showInformation() {
            showInformationCalled = true
        }
    }
    
    final class FetchDidUseCaseSpy: FetchDidUseCase {
        
        @Published var isExecuted = false
        @Published var isExecutedFilteredToday = false
        
        func executeFilteredByToday() async throws -> [DidTodayUIKit.Did] {
            isExecutedFilteredToday = true
            return [Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
        }
        
        func execute() async throws -> [DidTodayUIKit.Did] {
            isExecuted = true
            return [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
        }
    }
    
    //MARK: - Tests
    func test_fetchDids_shouldCallCoreDataStorage() {
        let promise = expectation(description: "Storage Be Called")
        fetchDidUseCaseSpy.$isExecutedFilteredToday
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        
        sut.fetchDids()
        wait(for: [promise], timeout: 2)
        XCTAssertTrue(fetchDidUseCaseSpy.isExecutedFilteredToday)
    }
    
    func test_fetchDids_shouldSendDidItemsList() {
        let promise = expectation(description: "Should Send Value")
        sut.didItemsList
            .sink { items in
                if !items.isEmpty {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        sut.fetchDids()
        wait(for: [promise], timeout: 1)
        
        let expectation = mockDids
            .filter { Calendar.current.isDateInToday($0.started) }
            .map { DidItemViewModel($0) }
            .sorted { $0.startedTimes > $1.startedTimes }
        
        XCTAssertEqual(sut.didItemsList.value, expectation)
    }
    
    func test_fetchDids_shouldSendTotalPieDids() {
        let promise = expectation(description: "Should Send Value")
        sut.totalPieDids
            .sink { item in
                if item != TotalOfDidsItemViewModel([]) {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        
        sut.fetchDids()
        wait(for: [promise], timeout: 1)
        
        let expectation = mockDids
            .filter { Calendar.current.isDateInToday($0.started) }
        
        XCTAssertEqual(sut.totalPieDids.value, TotalOfDidsItemViewModel(expectation))
    }
    
    func test_selectRecently_shouldBeSelectedRecentlyButtonAndNotSelectedMuchTimeButtonWhenIsNotSelectedRecentlyButtonAndSortedByStartedDate() {
        let promise = expectation(description: "Storage Be Called")
        fetchDidUseCaseSpy.$isExecutedFilteredToday
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        
        sut.fetchDids()
        wait(for: [promise], timeout: 2)
        
        //given
        sut.isSelectedRecentlyButton.value = false
        //when
        sut.selectRecently()
        //then
        XCTAssertTrue(sut.isSelectedRecentlyButton.value)
        XCTAssertFalse(sut.isSelectedMuchTimeButton.value)
    }

     func test_selectMuchTime_shouldBeSelectedRecentlyButtonAndNotSelectedMuchTimeButtonWhenIsNotSelectedRecentlyButtonAndSortedByMuchTime() {
        //given
        sut.isSelectedMuchTimeButton.value = false
        //when
        sut.selectMuchTime()
        //then
        XCTAssertTrue(sut.isSelectedMuchTimeButton.value)
        XCTAssertFalse(sut.isSelectedRecentlyButton.value)
    }
    //MARK: - Should I Test Remove Recorded about User Defaults?
    
    //MARK: Test of showing
    func test_showCreateDid() {
        //when
        sut.showCreateDid()
        //then
        XCTAssertTrue(coordinatorSpy.showCreateDidCalled)
    }
    
    func test_showCalendar() {
        //when
        sut.showCalendar()
        //then
        XCTAssertTrue(coordinatorSpy.showCalendarCalled)
    }
    
    func test_showDoing() {
        sut.showDoing()
        XCTAssert(coordinatorSpy.showDoingCalled)
    }
    
    func test_showAbout() {
        sut.showAbout()
        XCTAssert(coordinatorSpy.showInformationCalled)
    }
}

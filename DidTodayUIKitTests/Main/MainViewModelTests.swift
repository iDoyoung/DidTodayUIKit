//
//  MainViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/15.
//

import XCTest
@testable import DidTodayUIKit

class MainViewModelTests: XCTestCase {
    //MARK: - System Under Test
    var sut: MainViewModel!
    var didsCoreDataStorageSpy: DidsCoreDataStorageSpy!
    var coordinatorSpy: CoordinatorSpy!
    var mockDids = [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        didsCoreDataStorageSpy = DidsCoreDataStorageSpy()
        coordinatorSpy = CoordinatorSpy()
        sut = MainViewModel(didCoreDataStorage: didsCoreDataStorageSpy, router: MainRouter(showCalendar: coordinatorSpy.showCalendar(dids:),
                                                                                           showCreateDid: coordinatorSpy.showCreateDid))
        when_fetchDids_shouldCallDidsCoreDataStorageAndGetOutputDidItemsListAndTotalPieDids()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        didsCoreDataStorageSpy = nil
        coordinatorSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    class CoordinatorSpy {
        
        var showCalendarCalled = false
        var showCreateDidCalled = false
        
        func showCalendar(dids: [Did]) {
            showCalendarCalled = true
        }
        
        func showCreateDid() {
            showCreateDidCalled = true
        }
    }
    
    final class DidsCoreDataStorageSpy: DidCoreDataStorable {
        
        var dids: [Did]?
        var createDidCalled = false
        var fetchDidsCalled = false
        var updateDidCalled = false
        var deleteDidCalled = false
        
        func create(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            createDidCalled = true
        }
        
        func fetchDids(completion: @escaping ([Did], CoreDataStoreError?) -> Void) {
            fetchDidsCalled = true
            guard let dids = dids else {
                return
            }
            completion(dids, nil)
        }
        
        func update(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            updateDidCalled = true
        }
        
        func delete(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            deleteDidCalled = true
        }
    }
    
    //MARK: - Tests
    func when_fetchDids_shouldCallDidsCoreDataStorageAndGetOutputDidItemsListAndTotalPieDids() {
        //given
        let expectation = mockDids
            .filter { $0.started.omittedTime() == Date().omittedTime()}
            .sorted { $0.started < $1.started }
        let expectationOfDidItemsList = expectation.map { MainDidItemsViewModel($0) }
        let expectationOfTotalPieDids = MainTotalOfDidsItemViewModel(expectation)
        didsCoreDataStorageSpy.dids = mockDids
        //when
        sut.fetchDids()
        //then
        XCTAssert(didsCoreDataStorageSpy.fetchDidsCalled)
        XCTAssertEqual(expectationOfDidItemsList, sut.didItemsList.value)
        XCTAssertEqual(expectationOfTotalPieDids, sut.totalPieDids.value)
    }
    
    func test_selectRecently_shouldBeSelectedRecentlyButtonAndNotSelectedMuchTimeButtonWhenIsNotSelectedRecentlyButtonAndSortedByStartedDate() {
        let expectation = [Seeds.Dids.todayDidMock,
                           Seeds.Dids.todayDidMock2].map { MainDidItemsViewModel($0) }
        
        //given
        sut.isSelectedRecentlyButton.value = false
        //when
        sut.selectRecently()
        //then
        XCTAssertTrue(sut.isSelectedRecentlyButton.value)
        XCTAssertFalse(sut.isSelectedMuchTimeButton.value)
        XCTAssertEqual(expectation, sut.didItemsList.value)
    }
    
     func test_selectMuchTime_shouldBeSelectedRecentlyButtonAndNotSelectedMuchTimeButtonWhenIsNotSelectedRecentlyButtonAndSortedByMuchTime() {
         let expectation = [Seeds.Dids.todayDidMock2,
                            Seeds.Dids.todayDidMock].map { MainDidItemsViewModel($0) }
        //given
        sut.isSelectedMuchTimeButton.value = false
        //when
        sut.selectMuchTime()
        //then
        XCTAssertTrue(sut.isSelectedMuchTimeButton.value)
        XCTAssertFalse(sut.isSelectedRecentlyButton.value)
        XCTAssertEqual(expectation, sut.didItemsList.value)
    }
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
}

//
//  DoingViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/12/01.
//

import XCTest
@testable import DidTodayUIKit

final class DoingViewModelTests: XCTestCase {
    
    var sut: DoingViewModel!
    var timerMangerMock: TimerManagerSpy!
    var didCoreDataStorageSpy: DidCoreDataStorageSpy!
    var coordinatorSpy: CoordinatorSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        timerMangerMock = TimerManagerSpy()
        coordinatorSpy = CoordinatorSpy()
        didCoreDataStorageSpy = DidCoreDataStorageSpy()
        let mockRouter = DoingRouter(showCreateDid: coordinatorSpy.showCreateDid(started:ended:))
        sut = DoingViewModel(timerManager: timerMangerMock, router: mockRouter)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        timerMangerMock = nil
        didCoreDataStorageSpy = nil
        coordinatorSpy = nil
    }
    
    //MARK: Test Doubles
    final class DidCoreDataStorageSpy: DidCoreDataStorable {
        
        var createDidCalled = false
        var fetchDidsCalled = false
        var updateDidCalled = false
        var deleteDidCalled = false
        var error: CoreDataStoreError? = nil
        
        func create(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            createDidCalled = true
            completion(did, error)
        }
        
        func fetchDids(completion: @escaping ([Did], CoreDataStoreError?) -> Void) {
            fetchDidsCalled = true
        }
        
        func update(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            updateDidCalled = true
        }
        
        func delete(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            deleteDidCalled = true
        }
    }
    
    final class TimerManagerSpy: TimerManagerProtocol {
        
        var configureTimerCalled = false
        var startTimerCalled = false
        var stopTimerCalled = false
        var count: Double = 0
        
        func configureTimer(handler: @escaping () -> Void) {
            configureTimerCalled = true
        }
        
        func startTimer() {
            startTimerCalled = true
        }
        
        func stopTimer() {
            stopTimerCalled = true
        }
    }
    
    class CoordinatorSpy {
        
        var showCalendarCalled = false
        var showCreateDidCalled = false
        var showDoingCalled = false
        
        func showCalendar(dids: [Did]) {
            showCalendarCalled = true
        }
        
        func showCreateDid(started: Date?, ended: Date?) {
            showCreateDidCalled = true
        }
        
        func showDoing() {
            showDoingCalled = true
        }
    }
    
    enum ErrorMock: Error {
        case someError
    }
    
    //MARK: Tests
    func test_configure_shouldCallTimerManagerWhenInitViewModel() {
        ///then
        XCTAssert(timerMangerMock.configureTimerCalled)
    }
    
    func test_startDoing_shouldCallTimerManager() {
        ///given
        ///when
        sut.startDoing()
        ///then
        XCTAssert(timerMangerMock.startTimerCalled)
    }
    
    func test_stopDoing_shouldCallTimerManager() {
        ///given
        ///when
        sut.stopDoing()
        ///then
        XCTAssert(timerMangerMock.stopTimerCalled)
    }
}

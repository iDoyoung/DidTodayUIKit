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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        timerMangerMock = TimerManagerSpy()
        didCoreDataStorageSpy = DidCoreDataStorageSpy()
        sut = DoingViewModel(timerManager: timerMangerMock, didCoreDataStorage: didCoreDataStorageSpy)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        timerMangerMock = nil
        didCoreDataStorageSpy = nil
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
   
    func test_createDid_whenTitleIsNil_shouldNotCallDidCoreDataStorage() {
        ///given
        sut.colorOfPie.value = Did.PieColor(red: 1, green: 1, blue: 1, alpha: 1)
        sut.startedDate = Date()
        sut.endedDate = Date()
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createDid_whenColorIsNil_shouldNotCallDidCoreDataStorage() {
        ///given
        sut.titleOfDid.value = "Test"
        sut.startedDate = Date()
        sut.endedDate = Date()
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createDid_whenEndDateIsNil_shouldNotCallDidCoreDataStorage() {
        ///given
        sut.titleOfDid.value = "Test"
        sut.colorOfPie.value = Did.PieColor(red: 1, green: 1, blue: 1, alpha: 1)
        sut.startedDate = Date()
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createDid_whenStartDateIsNil_shouldNotCallDidCoreDataStorage() {
        ///given
        sut.titleOfDid.value = "Test"
        sut.colorOfPie.value = Did.PieColor(red: 1, green: 1, blue: 1, alpha: 1)
        sut.endedDate = Date()
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createDid_whenSucceedCreate_shouldCallDidCoreDataStorageAndBeErrorNilAndIsSucceededCreated() {
        ///given
        sut.titleOfDid.value = "Test"
        sut.colorOfPie.value = Did.PieColor(red: 1, green: 1, blue: 1, alpha: 1)
        sut.startedDate = Date()
        sut.endedDate = Date()
        ///when
        sut.createDid()
        ///then
        XCTAssert(didCoreDataStorageSpy.createDidCalled)
        XCTAssertNil(sut.error.value)
        XCTAssert(sut.isSucceededCreated.value)
    }
    
    func test_createDid_whenFailCreateWithError_shouldCallDidCoreDataStorageAndBeErrorIsNotNilAndIsSucceededCreatedFalse() {
       ///given
        sut.titleOfDid.value = "Test"
        sut.colorOfPie.value = Did.PieColor(red: 1, green: 1, blue: 1, alpha: 1)
        sut.startedDate = Date()
        sut.endedDate = Date()
        didCoreDataStorageSpy.error = CoreDataStoreError.saveError(ErrorMock.someError)
        ///when
        sut.createDid()
        ///then
        XCTAssert(didCoreDataStorageSpy.createDidCalled)
        XCTAssertNotNil(sut.error.value)
        XCTAssertFalse(sut.isSucceededCreated.value)
    }
}

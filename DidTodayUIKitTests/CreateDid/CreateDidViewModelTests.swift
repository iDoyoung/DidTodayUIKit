//
//  CreateDidViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/21.
//

import XCTest
@testable import DidTodayUIKit

class CreateDidViewModelTests: XCTestCase {
    //MARK: - System Under Test
    var sut: CreateDidViewModel!
    var didCoreDataStorageSpy: DidCoreDataStorageSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        didCoreDataStorageSpy = DidCoreDataStorageSpy()
        sut = CreateDidViewModel(didCoreDataStorage: didCoreDataStorageSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        didCoreDataStorageSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    enum ErrorMock: Error {
        case someError
    }
    
    final class DidCoreDataStorageSpy: DidCoreDataStorable {
        var error: CoreDataStoreError?
        
        var createDidCalled = false
        var fetchDidsCalled = false
        var updateDidCalled = false
        var deleteDidCalled = false
        
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
    
    //MARK: - Tests
    
    ///Test Set Title
    func test_setTitle_shouldSendInputToOutputOfTitleAndNotTitleIsEmpty_whenTextIsNotEmpty() {
        let text = "Mock"
        sut.setTitle(text)
        XCTAssertEqual(text, sut.titleOfDid.value)
        XCTAssertFalse(sut.titleIsEmpty.value)
    }
    
    func test_setTitle_shouldSendInputToOutputOfTitleAndTitleIsEmptyIsTrue_whenTextIsEmpty() {
        let text = ""
        sut.setTitle(text)
        XCTAssertEqual(text, sut.titleOfDid.value)
        XCTAssert(sut.titleIsEmpty.value)
    }
   
    ///Test Set Color
    func test_setColorOfPie() {
        let themeColor = UIColor.themeGreen
        sut.setColorOfPie(themeColor)
        XCTAssertEqual(themeColor, sut.colorOfPie.value)
    }
    
    ///Test Set Time
    func test_degreeOfStartedTime_whenTimeIsMidnight() {
        let midnight = Seeds.MockDate.midnight
        sut.startedTime.send(midnight)
        XCTAssertEqual(sut.degreeOfStartedTime.value, 0)
    }
    
    func test_degreeOfStartedTime_whenTimeIsNoon() {
        let noon = Seeds.MockDate.noon
        sut.startedTime.send(noon)
        XCTAssertEqual(sut.degreeOfStartedTime.value, 180)
    }
    
    func test_degreeOfEndedTime_whenTimeIsMidnight() {
        let midnight = Seeds.MockDate.midnight
        sut.startedTime.send(midnight)
        XCTAssertEqual(sut.degreeOfStartedTime.value, 0)
    }
    
    func test_degreeOfEndedTime_whenTimeIsNoon() {
        let noon = Seeds.MockDate.noon
        sut.startedTime.send(noon)
        XCTAssertEqual(sut.degreeOfStartedTime.value, 180)
    }
    
    func test_degreeOfStartedTimeShouldBeNil_whenInputOfStartedTimeIsNil() {
        sut.startedTime.send(nil)
        XCTAssertNil(sut.degreeOfStartedTime.value)
    }
    
    func test_degreeOfEndedTimeShouldBeNil_whenInputOfEndedTimeIsNil() {
        sut.endedTime.send(nil)
        XCTAssertNil(sut.degreeOfEndedTime.value)
    }
    
    ///Test Create
    func test_createShouldBeCompletedCallCoreDataStorage_whenInputAllAndErrorIsNil() {
        ///given
        let text = "Title"
        let themeColor = UIColor.themeGreen
        let midnight = Seeds.MockDate.midnight
        let noon = Seeds.MockDate.noon
        
        sut.setTitle(text)
        sut.setColorOfPie(themeColor)
        sut.startedTime.send(midnight)
        sut.endedTime.send(noon)
        
        ///when
        sut.createDid()
        ///then
        XCTAssert(sut.isCompleted.value)
        XCTAssert(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createShouldNotBeCompletedAndNotCallCoreDataStorage_whenTitleOuputIsNil() {
        ///given
        let themeColor = UIColor.themeGreen
        let midnight = Seeds.MockDate.midnight
        let noon = Seeds.MockDate.noon
        
        sut.setColorOfPie(themeColor)
        sut.startedTime.send(midnight)
        sut.endedTime.send(noon)
        
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssertFalse(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createShouldBeCompletedAndCallCoreDataStorage_whenDontSetColor() {
        ///given
        let text = "Title"///
        let midnight = Seeds.MockDate.midnight
        let noon = Seeds.MockDate.noon
        
        sut.setTitle(text)
        sut.startedTime.send(midnight)
        sut.endedTime.send(noon)
        
        ///when
        sut.createDid()
        ///then
        XCTAssert(sut.isCompleted.value)
        XCTAssert(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createShouldNotBeCompletedAndNotCallCoreDataStorage_whenEndedTimeOutputIsNil() {
        ///given
        let text = "Title"///
        let noon = Seeds.MockDate.noon
        
        sut.setTitle(text)
        sut.endedTime.send(noon)
        
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssertFalse(didCoreDataStorageSpy.createDidCalled)
    }
    
    func test_createShouldNotBeCompletedAndNotCallCoreDataStorage_whenStartedTimeOutputIsNil() {
        ///given
        let text = "Title"
        let midnight = Seeds.MockDate.midnight
        
        sut.setTitle(text)
        sut.startedTime.send(midnight)
        
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssertFalse(didCoreDataStorageSpy.createDidCalled)
    }
    
    
    func test_create_shouldBeNotCompletedAndCallCoreDataStorageAndOutputOfErrorIsNotNil_whenReceiveCoreDataError() {
        ///given
        let saveError = CoreDataStoreError.saveError(ErrorMock.someError)
        let text = "Title"
        let midnight = Seeds.MockDate.midnight
        let noon = Seeds.MockDate.noon
        
        didCoreDataStorageSpy.error = saveError
        sut.setTitle(text)
        sut.startedTime.send(midnight)
        sut.endedTime.send(noon)
        
        ///when
        sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssert(didCoreDataStorageSpy.createDidCalled)
        XCTAssertNotNil(sut.error.value)
    }
}

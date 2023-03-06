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
    var createDidUseCaseSpy: CreateDidUseCaseSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        createDidUseCaseSpy = CreateDidUseCaseSpy()
        sut = CreateDidViewModel(createDidUseCase: createDidUseCaseSpy, startedDate: nil, endedDate: nil, fromDoing: false)
    }

    override func tearDownWithError() throws {
        sut = nil
        createDidUseCaseSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    enum ErrorMock: Error {
        case someError
    }
    
    final class CreateDidUseCaseSpy: CreateDidUseCase {
        var isExecuted = false
        var error: CoreDataStoreError?
        
        func execute(_ did: DidTodayUIKit.Did) async throws -> DidTodayUIKit.Did {
            isExecuted = true
            guard let error = error else {
                return Seeds.Dids.christmasParty
            }
            throw error
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
    
    func test_degreeOfEndedTimeShouldBeNotNil_whenInputOfEndedTimeIsNil() {
        sut.endedTime.send(nil)
        XCTAssertNotNil(sut.degreeOfEndedTime.value)
    }
    
    ///Test Create
    func test_createShouldBeCompletedCallCoreDataStorage_whenInputAllAndErrorIsNil() async {
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
        await sut.createDid()
        ///then
        XCTAssert(sut.isCompleted.value)
        XCTAssert(createDidUseCaseSpy.isExecuted)
    }
    
    func test_createShouldNotBeCompletedAndNotCallCoreDataStorage_whenTitleOuputIsNil() async {
        ///given
        let themeColor = UIColor.themeGreen
        let midnight = Seeds.MockDate.midnight
        let noon = Seeds.MockDate.noon
        
        sut.setColorOfPie(themeColor)
        sut.startedTime.send(midnight)
        sut.endedTime.send(noon)
        
        ///when
        await sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssertFalse(createDidUseCaseSpy.isExecuted)
    }
    
    func test_createShouldBeCompletedAndCallCoreDataStorage_whenDontSetColor() async {
        ///given
        let text = "Title"
        let midnight = Seeds.MockDate.midnight
        let noon = Seeds.MockDate.noon
        
        sut.setTitle(text)
        sut.startedTime.send(midnight)
        sut.endedTime.send(noon)
        
        ///when
        await sut.createDid()
        ///then
        XCTAssert(sut.isCompleted.value)
        XCTAssert(createDidUseCaseSpy.isExecuted)
    }
    
    func test_createShouldNotBeCompletedAndNotCallCoreDataStorage_whenEndedTimeOutputIsNil() async {
        ///given
        let text = "Title"///
        let noon = Seeds.MockDate.noon
        
        sut.setTitle(text)
        sut.endedTime.send(noon)
        
        ///when
        await sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssertFalse(createDidUseCaseSpy.isExecuted)
    }
    
    func test_createShouldNotBeCompletedAndNotCallCoreDataStorage_whenStartedTimeOutputIsNil() async {
        ///given
        let text = "Title"
        let midnight = Seeds.MockDate.midnight
        
        sut.setTitle(text)
        sut.startedTime.send(midnight)
        
        ///when
        await sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssertFalse(createDidUseCaseSpy.isExecuted)
    }
    
    
    func test_create_shouldBeNotCompletedAndCallCoreDataStorageAndOutputOfErrorIsNotNil_whenReceiveCoreDataError() async {
        ///given
        let saveError = CoreDataStoreError.saveError(ErrorMock.someError)
        let text = "Title"
        let midnight = Seeds.MockDate.midnight
        let noon = Seeds.MockDate.noon
        
        createDidUseCaseSpy.error = saveError
        sut.setTitle(text)
        sut.startedTime.send(midnight)
        sut.endedTime.send(noon)
        
        ///when
        await sut.createDid()
        ///then
        XCTAssertFalse(sut.isCompleted.value)
        XCTAssert(createDidUseCaseSpy.isExecuted)
        XCTAssertNotNil(sut.creatingError.value)
    }
}

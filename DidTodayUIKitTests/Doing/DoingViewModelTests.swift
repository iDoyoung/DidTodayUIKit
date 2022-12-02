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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        timerMangerMock = TimerManagerSpy()
        sut = DoingViewModel(timerManager: timerMangerMock)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        timerMangerMock = nil
    }

    //MARK: Test Doubles
    final class TimerManagerSpy: TimerManagerProtocol {
        
        var configureTimerCalled = false
        var startTimerCalled = false
        var stopTimerCalled = false
        var count: Double = 0
        
        func configureTimer() {
            configureTimerCalled = true
        }
        
        func startTimer() {
            startTimerCalled = true
        }
        
        func stopTimer() {
            stopTimerCalled = true
        }
    }

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

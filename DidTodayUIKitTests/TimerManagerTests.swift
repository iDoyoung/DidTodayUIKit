//
//  TimerManagerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/12/01.
//

import XCTest
@testable import DidTodayUIKit

final class TimerManagerTests: XCTestCase {

    var sut: TimerManager!
    var count: Int!
    
    private func countHandler() {
        count += 1
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TimerManager()
        count = 0
    }

    override func tearDownWithError() throws {
        count = nil
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_configureTimer() {
        ///given
        ///when
        sut.configureTimer(handler: countHandler)
        ///then
        XCTAssertNotNil(sut.timer)
        }
    
    func test_startTimer_shouldCountThreeDuringThreeSeconds() {
        ///given
        sut.configureTimer(handler: countHandler)
        ///when
        sut.startTimer()
        ///then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            XCTAssertEqual(self?.count, 3)
        }
    }
    
    func test_stopTimer_afterThree_shouldCountThreeDuringFiveSeconds() {
        ///given
        sut.configureTimer(handler: countHandler)
        sut.startTimer()
        ///when
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.sut.stopTimer()
        }
        ///then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            XCTAssertEqual(self?.count, 3)
        }
    }
    
    func test_startTimer_whenRestartAfterStopTimer() {
        ///given
        sut.configureTimer(handler: countHandler)
        ///when
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.sut.stopTimer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.sut.startTimer()
        }
        ///then
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            XCTAssertEqual(self?.count, 8)
        }
    }
}

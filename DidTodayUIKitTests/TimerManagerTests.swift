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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TimerManager()
    }

    override func tearDownWithError() throws {
        sut.timer?.cancel()
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_configureTimer() {
        ///given
        ///when
        sut.configureTimer()
        ///then
        XCTAssertNotNil(sut.timer)
        sut.timer?.resume()
    }
    
    func test_startTimer_shouldCountThreeDuringThreeSeconds() {
        ///given
        sut.configureTimer()
        ///when
        sut.startTimer()
        ///then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            XCTAssertEqual(self?.sut.count, 3)
        }
    }
    
    func test_stopTimer_afterThree_shouldCountThreeDuringFiveSeconds() {
        ///given
        sut.configureTimer()
        sut.startTimer()
        ///when
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.sut.stopTimer()
        }
        ///then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            XCTAssertEqual(self?.sut.count, 3)
        }
    }
}

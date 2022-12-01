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
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_configureTimer() {
        ///given
        ///when
        sut.configureTimer {
            print("Event")
        }
        ///then
        sut.timer?.resume()
        XCTAssertNotNil(sut.timer)
    }
}

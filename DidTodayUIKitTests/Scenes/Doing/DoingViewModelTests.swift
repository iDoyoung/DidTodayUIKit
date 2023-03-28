//
//  DoingViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/12/01.
//

import XCTest
import Combine
@testable import DidTodayUIKit

final class DoingViewModelTests: XCTestCase {
    
    var sut: DoingViewModel!
    var coordinatorSpy: CoordinatorSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coordinatorSpy = CoordinatorSpy()
        let mockRouter = DoingRouter(showCreateDid: coordinatorSpy.showCreateDid(started:ended:))
        sut = DoingViewModel(router: mockRouter)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        coordinatorSpy = nil
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
    
    //MARK: Tests
    
    func test_updateCountWithStartedDate() {
        // when
        sut.updateCountWithStartedDate()
        // then
        XCTAssertEqual(sut.cancellablesBag.count, 1, "Unexpected number of cancellables")
        if UserDefaults.standard.object(forKey: "start-time-of-doing") == nil {
            XCTAssertEqual(sut.timesOfTimer.value, "00:00")
        }
    }
    
    ///Timer Publisher Should Attach a subscriber
    func test_countTime() {
        // given
        sut.cancellablesBag.removeAll()
        // when
        sut.countTime()
        // then
        XCTAssertEqual(sut.cancellablesBag.count, 1, "Unexpected number of cancellables")
    }
    
    func test_observeDidEnterBackground() {
        //given
        sut.cancellablesBag.removeAll()
        // when
        sut.observeDidEnterBackground()
        // then
        XCTAssertEqual(sut.cancellablesBag.count, 1, "Unexpected number of cancellables")
    }
    
    func test_observeWillEnterForeground() {
        //given
        sut.cancellablesBag.removeAll()
        // when
        sut.observeWillEnterForeground()
        
        // then
        XCTAssertEqual(sut.cancellablesBag.count, 1, "Unexpected number of cancellables")
    }
    
    func test_showCreateDid() {
        sut.showCreateDid()
        XCTAssertEqual(coordinatorSpy.showCreateDidCalled, true)
    }
}

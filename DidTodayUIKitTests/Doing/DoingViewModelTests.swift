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
    func test_showCreateDid_whenGivenStartedDate_shouldCallCoordinator() {
        sut.startedDate = Date()
        sut.showCreateDid()
        XCTAssertTrue(coordinatorSpy.showCreateDidCalled)
    }
   
    func test_showCreateDid_whenGivenNothing_shouldNotCallCoordinator() {
        sut.showCreateDid()
        XCTAssertFalse(coordinatorSpy.showCreateDidCalled)
    }
}

//
//  DidDetailsViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/03/11.
//

import XCTest
@testable import DidTodayUIKit

final class DidDetailsViewModelTests: XCTestCase {
    
    //MARK: - System Under Test
    var sut: DidDetailsViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_initailize_shouldBeGetOutputOfDate() {
        let promise = expectation(description: "Get output of Date")
        ///given
        let mockDid = Seeds.Dids.christmasParty
        ///when
        sut = DidDetailsViewModel(mockDid)
        ///then
        let _ = sut.date.sink { result in
            XCTAssertEqual(result, "Dec 25, 2021")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_initailize_shouldBeGetOutputOfTitle() {
        let promise = expectation(description: "Get output of Title")
        ///given
        let mockDid = Seeds.Dids.christmasParty
        ///when
        sut = DidDetailsViewModel(mockDid)
        ///then
        let _ = sut.title.sink { result in
            XCTAssertEqual(result, "Christmas Party")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_initailize_shouldBeGetOutputOfDidTime() {
        let promise = expectation(description: "Get output of Did Time")
        ///given
        let mockDid = Seeds.Dids.christmasParty
        ///when
        sut = DidDetailsViewModel(mockDid)
        ///then
        let _ = sut.didTime.sink { result in
            XCTAssertEqual(result, "Did 0: 0")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_initailize_shouldBeGetOutputOfTimeRange() {
        let promise = expectation(description: "Get output of Time Range")
        ///given
        let mockDid = Seeds.Dids.christmasParty
        ///when
        sut = DidDetailsViewModel(mockDid)
        ///then
        let _ = sut.timeRange.sink { result in
            XCTAssertEqual(result, "12:00 AM - 12:00 AM")
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
    
    func test_initailize_shouldBeGetOutputOfColor() {
        let promise = expectation(description: "Get output of Color")
        ///given
        let mockDid = Seeds.Dids.christmasParty
        ///when
        sut = DidDetailsViewModel(mockDid)
        ///then
        let _ = sut.color.sink { result in
            XCTAssertEqual(result, UIColor(red: 0, green: 0, blue: 0, alpha: 0))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
    }
}

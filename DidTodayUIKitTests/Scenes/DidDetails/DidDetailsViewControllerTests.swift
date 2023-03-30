//
//  DidDetailsViewControllerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/03/30.
//

import XCTest
import Combine
@testable import DidTodayUIKit

final class DidDetailsViewControllerTests: XCTestCase {

    //MARK: - System under test
    var sut: DidDetailsViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        didDetailsViewModelSpy = DidDetailsViewModelSpy()
        sut = DidDetailsViewController.create(with: didDetailsViewModelSpy)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        didDetailsViewModelSpy = nil
        try super.tearDownWithError()
    }

    //MARK: - Test Doubles
    var didDetailsViewModelSpy: DidDetailsViewModelSpy!
    class DidDetailsViewModelSpy: DidDetailsViewModelProtocol {
        
        var date: Just<String?> = Just("20230330")
        var title: Just<String?> = Just("Title")
        var didTime: Just<String?> = Just("3")
        var startedTime: Just<String?> = Just("10:10")
        var finishedTime: Just<String?> = Just("11:11")
        var color: Just<UIColor?> = Just(UIColor.green)
        
        var deleteCalled = false
        
        func delete() async throws {
            deleteCalled = true
        }
    }
    
    //MARK: - Tests
    func test_titleLabel_bindingWithViewModel() {
        // given
        let expectation = "Title"
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.didDetailView.titleLabel.text, expectation)
    }
    
    func test_didTimeLabel_bindingWithViewModel() {
        // given
        let expectation = "3"
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.didDetailView.didTimeLabel.text, expectation)
    }
    
    func test_timeRangeLabel_bindingWithViewModel() {
        // given
        let expectation = "10:10 - 11:11"
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.didDetailView.timeRangeLabel.text, expectation)
    }
    
    func test_color_bindingWithViewModel() {
        // given
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertEqual(sut.didDetailView.color, .green)
    }
}

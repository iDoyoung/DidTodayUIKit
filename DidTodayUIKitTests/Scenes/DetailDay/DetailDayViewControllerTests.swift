//
//  DetailDayViewControllerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/03/30.
//

import XCTest
import Combine
@testable import DidTodayUIKit

final class DetailDayViewControllerTests: XCTestCase {

    //MARK: - System Under Test
    var sut: DetailDayViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DetailDayViewController.create(with: detailDayViewModelSpy)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test Doubles
    var detailDayViewModelSpy = DetailDayViewModelSpy()
    final class DetailDayViewModelSpy: DetailDayViewModelProtocol {
        
        var fetchDidsCalled = false
        var selectRecentlyCalled = false
        var selectMuchTimeCalled = false
        var didSelectItemCalled = false
        
        func fetchDids() {
            fetchDidsCalled = true
        }
        
        func selectRecently() {
            selectRecentlyCalled = true
        }
        
        func selectMuchTime() {
            selectMuchTimeCalled = true
        }
        
        func didSelectItem(at index: Int) {
            didSelectItemCalled = true
        }
        
        var selectedDay = CurrentValueSubject<String?, Never>(nil)
        var totalPieDids = CurrentValueSubject<TotalOfDidsItemViewModel, Never>(TotalOfDidsItemViewModel([]))
        var didItemsList = CurrentValueSubject<[DidItemViewModel], Never>([])
        var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
        var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(false)
    }
    
    //MARK: - Tests
    
    //MARK: Test View Will Appear
    //TODO: Consider how to test collection view cell
    
    func test_tapRecentlyButton() {
        // when
        sut.tapRecentlyButton(UIButton())
        
        // then
        XCTAssertTrue(detailDayViewModelSpy.selectRecentlyCalled)
    }
    
    func test_tapMuchTimeButton() {
        // when
        sut.tapMuchTimeButton(UIButton())
        
        // then
        XCTAssertTrue(detailDayViewModelSpy.selectMuchTimeCalled)
    }
}

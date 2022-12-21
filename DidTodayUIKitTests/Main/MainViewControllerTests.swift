//
//  MainViewControllerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/18.
//

import XCTest
import Combine
@testable import DidTodayUIKit

class MainViewControllerTests: XCTestCase {
    //MARK: - Sytem under test
    var sut: MainViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainViewController()
    }
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    private class MainViewModelSpy: MainViewModelInput, MainViewModelOutput {
        ///Input
        var fetchDidsCalled  = false
        var selectRecentlyCalled = false
        var selectMuchTimeCalled = false
        
        func fetchDids() {
            fetchDidsCalled = true
        }
        
        func selectRecently() {
            selectRecentlyCalled = true
        }
        
        func selectMuchTime() {
            selectMuchTimeCalled = true
        }
        
        ///Output
        var showCreateDidCalled = false
        var showCalendarCalled = false
        var showDoingCalled = false
        
        var totalPieDids = CurrentValueSubject<MainTotalOfDidsItemViewModel, Never>(MainTotalOfDidsItemViewModel([]))
        
        var didItemsList = CurrentValueSubject<[MainDidItemsViewModel], Never>([])
        var isSelectedRecentlyButton = CurrentValueSubject<Bool, Never>(true)
        var isSelectedMuchTimeButton = CurrentValueSubject<Bool, Never>(true)
        
        func showCreateDid() {
            showCreateDidCalled = true
        }

        func showCalendar() {
            showCalendarCalled = true
        }
        
        func showDoing() {
            showDoingCalled = true
        }
    }
    
    //MARK: - Tests
    func test_fetcnDids_shouldCallViewModel_whenViewDidLoad() {
        //given
        let viewModelSpy = MainViewModelSpy()
        sut.viewModel = viewModelSpy
        //when
        sut.viewDidLoad()
        //then
        XCTAssert(viewModelSpy.fetchDidsCalled)
    }
}

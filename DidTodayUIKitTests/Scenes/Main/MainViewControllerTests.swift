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
        var showAboutCalled = false
        var removeRecordedCalled = false
        
        func fetchDids() {
            fetchDidsCalled = true
        }
        
        func selectRecently() {
            selectRecentlyCalled = true
        }
        
        func selectMuchTime() {
            selectMuchTimeCalled = true
        }
        
        func removeRecorded() {
            removeRecordedCalled = true
        }
        
        func didSelectItem(at index: Int) {
            
        }
        
        ///Output
        var hasRecordedBeforeClose: Just<Date?> = Just(nil)
        var showCreateDidCalled = false
        var showCalendarCalled = false
        var showDoingCalled = false
        
        var totalPieDids = CurrentValueSubject<TotalOfDidsItemViewModel, Never>(TotalOfDidsItemViewModel([]))
        
        var didItemsList = CurrentValueSubject<[DidItemViewModel], Never>([])
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
        
        func showAbout() {
            showAboutCalled = true
        }
    }
    
    //MARK: - Tests
    func test_fetchDids_shouldCallViewModel_whenViewWillAppear() {
        //given
        let viewModelSpy = MainViewModelSpy()
        sut.viewModel = viewModelSpy
        //when
        sut.viewWillAppear(true)
        //then
        XCTAssert(viewModelSpy.fetchDidsCalled)
    }
    
    func test_okayAboutMainAlert_shouldCallViewModel() {
        //given
        let viewModelSpy = MainViewModelSpy()
        sut.viewModel = viewModelSpy
        //when
        sut.okay()
        //then
        XCTAssert(viewModelSpy.removeRecordedCalled)
    }
}

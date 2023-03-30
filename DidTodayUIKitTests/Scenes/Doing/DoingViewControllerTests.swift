//
//  DoingViewControllerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/03/29.
//

import XCTest
import Combine
@testable import DidTodayUIKit

final class DoingViewControllerTests: XCTestCase {

    var sut: DoingViewController!
    let date = Date()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // given
        sut = DoingViewController.create(with: doingViewModelSpy)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }

    //MARK: - Test Doubles
    
    var doingViewModelSpy = DoingViewModelSpy()
    class DoingViewModelSpy: DoingViewModelProtocol {
        
        var requestUserNotificationsAuthorizationCalled = false
        
        func requestUserNotificationsAuthorization() {
            requestUserNotificationsAuthorizationCalled = true
        }
        
        var updateCountWithStartedDateCalled = false
        
        func updateCountWithStartedDate() {
            updateCountWithStartedDateCalled = true
        }
        
        var countTimeCalled = false
        
        func countTime() {
            countTimeCalled = true
        }
        
        var viewDisappearCalled = false
        
        func viewDisappear() {
            viewDisappearCalled = true
        }
        
        var showCreateDidCalled = false
        
        func showCreateDid() {
            showCreateDidCalled = true
        }
        
        var cancelRecordingCalled = false
        
        func cancelRecording() {
            cancelRecordingCalled = true
        }
        
        var observeDayIsChangedCalled = false
        
        func observeDayIsChanged() {
            observeDayIsChangedCalled = true
        }
        
        var observeDidEnterBackgroundCalled = false
        
        func observeDidEnterBackground() {
            observeDidEnterBackgroundCalled = true
        }
        
        var observeWillEnterForegroundCalled = false
        
        func observeWillEnterForeground() {
            observeWillEnterForegroundCalled = true
        }
        
        var startedTimeText: AnyPublisher<String?, Never> = Just(Seeds.MockDate.midnight!)
            .map { CustomText.started(time: $0.currentTimeToString()) }
            .eraseToAnyPublisher()
        var timesOfTimer = CurrentValueSubject<String?, Never>("00:00")
        var isLessThanTime = CurrentValueSubject<Bool, Never>(true)
    }
    
    //MARK: - Tests
    func test_viewDidLoad_shouldCallObserveWillEnterForeground() {
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(doingViewModelSpy.observeWillEnterForegroundCalled)
    }
    
    func test_viewDidLoad_shouldCallObserveDidEnterBackground() {
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(doingViewModelSpy.observeDidEnterBackgroundCalled)
    }
    
    func test_viewDidLoad_shouldCallObserveDayIsChanged() {
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(doingViewModelSpy.observeDayIsChangedCalled)
    }
    
    func test_viewDidLoad_shouldCallRequestUserNotificationsAuthorization() {
        // when
        sut.viewDidLoad()
        // then
        XCTAssertTrue(doingViewModelSpy.requestUserNotificationsAuthorizationCalled)
    }
    
    //MARK: Test View Will Disappear
    
    func test_viewWillDisappear() {
        // when
        sut.viewWillDisappear(false)
        // then
        XCTAssertTrue(doingViewModelSpy.viewDisappearCalled)
    }
    
    //MARK: Test Binding
    
    func test_bindingWithViewModel() {
        // when
        sut.viewDidLoad()
        //then
        XCTAssertEqual(sut.timerLabel.text, "00:00")
    }
    
    func test_bindingViewViewModel_() {
        // when
        sut.viewDidLoad()
        // then
        XCTAssertEqual(sut.startedTimeLabel.text, "Started Time: 12:00 AM")
    }
}

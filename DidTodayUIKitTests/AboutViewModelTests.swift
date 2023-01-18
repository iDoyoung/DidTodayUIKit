//
//  AboutViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/01/18.
//

import XCTest
@testable import DidTodayUIKit

final class AboutViewModelTests: XCTestCase {

    //MARK: - System Under Test
    var sut: AboutViewModel!
    let routerSpy = RouterSpy()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AboutViewModel(router: routerSpy.router)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test Double
    class RouterSpy {
        var showActivityToRecommendCalled = false
        var openAppStoreToReviewCalled = false
        var showPrivacyPolicyCalled = false
        
        lazy var router = AboutRouter(showActivityToRecommend: showActivityToRecommend(_:), openAppStoreToReview: openAppStoreToReview, showPrivacyPolicy: showPrivacyPolicy)
        
        func showActivityToRecommend(_ : [String]) {
            showActivityToRecommendCalled = true
        }
        
        func openAppStoreToReview() {
            openAppStoreToReviewCalled = true
        }
        
        func showPrivacyPolicy() {
            showPrivacyPolicyCalled = true
        }
    }
    
    //MARK: - Tests
    func test_selecting_whenSelectIndexOf0_shouldCallShowActivityToRecommendOnly() {
        ///given
        let index = 0
        ///when
        sut.select(index)
        ///then
        XCTAssert(routerSpy.showActivityToRecommendCalled)
        XCTAssertFalse(routerSpy.openAppStoreToReviewCalled)
        XCTAssertFalse(routerSpy.showPrivacyPolicyCalled)
    }
    
    func test_selecting_whenSelectIndexOf1_shouldCallOpenAppStoreToReviewOnly() {
        ///given
        let index = 1
        ///when
        sut.select(index)
        ///then
        XCTAssert(routerSpy.openAppStoreToReviewCalled)
        XCTAssertFalse(routerSpy.showPrivacyPolicyCalled)
        XCTAssertFalse(routerSpy.showActivityToRecommendCalled)
    }
    
    func test_selecting_whenSelectIndexOf2_shouldCallShowPrivacyPolicyOnly() {
        ///given
        let index = 2
        ///when
        sut.select(index)
        ///then
        XCTAssert(routerSpy.showPrivacyPolicyCalled)
        XCTAssertFalse(routerSpy.openAppStoreToReviewCalled)
        XCTAssertFalse(routerSpy.showActivityToRecommendCalled)
    }
}

//
//  MainViewControllerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/18.
//

import XCTest
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
        /// Input
        var fetchDidsCalled = false
        func fetchDids() {
            fetchDidsCalled = true
        }
        /// Output
        @Published var fetchedDids: [MainDidItemsViewModel]?
        var fetchedDidsPublisher: Published<[MainDidItemsViewModel]?>.Publisher {
            $fetchedDids
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

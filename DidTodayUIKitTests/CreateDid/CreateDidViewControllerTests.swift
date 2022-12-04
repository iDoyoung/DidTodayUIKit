//
//  CreateDidViewControllerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/21.
//

import XCTest
@testable import DidTodayUIKit

class CreateDidViewControllerTests: XCTestCase {
    //MARK: - System Under Tests
    var sut: CreateDidViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreateDidViewController()
    }
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    class CreateDidViewModelSpy: CreateDidViewModelInput, CreateDidViewModelOutput {
        var createDidCalled = false
        //MARK: - Input
        @Published var startedTime: Date?
        @Published var endedTime: Date?
        @Published var color: UIColor?
        @Published var title: String?
        
        func createDid(completion: @escaping (Result<Did, CreateDidError>) -> Void) {
            createDidCalled = true
        }
        
        //MARK: - Output
        var startedTimePublished: Published<Date?>.Publisher { $startedTime }
        var endedTimePublished: Published<Date?>.Publisher { $endedTime }
        var colorPublished: Published<UIColor?>.Publisher { $color }
        var titlePublisher: Published<String?>.Publisher { $title }
    }
    
    //MARK: - Tests
    func test_addDid_shouldCallViewModel() {
        //given
        let viewModelSpy = CreateDidViewModelSpy()
        sut.viewModel = viewModelSpy
        //when
        //sut.addDid(UIBarButtonItem())
        //then
        //XCTAssert(viewModelSpy.createDidCalled)
    }
    
}

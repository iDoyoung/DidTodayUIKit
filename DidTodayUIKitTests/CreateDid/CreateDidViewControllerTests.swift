//
//  CreateDidViewControllerTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/21.
//

import XCTest
import Combine
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
    class CreateDidViewModelSpy: CreateDidViewModelProtocol {
        
        //MARK: - Input
        
        var setTitleCalled = false
        var setColorOfPieCalled = false
        var createCalled = false
        
        var startedTime = CurrentValueSubject<Date?, Never>(nil)
        var endedTime = CurrentValueSubject<Date?, Never>(nil)
        
        func setTitle(_ title: String) {
            setTitleCalled = true
        }
        
        func setColorOfPie(_ color: UIColor) {
            setColorOfPieCalled = true
        }
        
        func createDid() {
            createCalled = true
        }
        
        //MARK: - Output
        var titleOfDid = CurrentValueSubject<String?, Never>(nil)
        var titleIsEmpty = CurrentValueSubject<Bool, Never>(true)
        var colorOfPie = CurrentValueSubject<UIColor, Never>(.customGreen)
        var degreeOfStartedTime = CurrentValueSubject<Double?, Never>(nil)
        var degreeOfEndedTime = CurrentValueSubject<Double?, Never>(nil)
        var isCompleted = CurrentValueSubject<Bool, Never>(false)
        var error = CurrentValueSubject<DidTodayUIKit.CoreDataStoreError?, Never>(nil)
        
        func initialStartedTime() -> Date {
            return Calendar.current.startOfDay(for: Date())
        }
        
        func initialEndedTime() -> Date {
            return Date()
        }
    }
    
    //TODO: Interface Builder Test?
    ///Storyboard와 사용한 View Controller의 경우 Interface Builder의 옵셔널 언랩핑을 사용여부
    ///UI Delegate의 경우 테스트 여부
    //MARK: - Tests
    func test_createDid_shouldCallViewModel() {
        //given
        let viewModelSpy = CreateDidViewModelSpy()
        viewModelSpy.titleIsEmpty.send(false)
        sut.viewModel = viewModelSpy
        //when
        sut.createDid(UIButton())
        //then
        XCTAssert(viewModelSpy.setTitleCalled)
    }
}

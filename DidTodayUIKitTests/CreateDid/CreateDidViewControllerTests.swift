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
    var viewModelSpy: CreateDidViewModelSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModelSpy = CreateDidViewModelSpy()
        sut = CreateDidViewController()
        sut = CreateDidViewController.create(with: viewModelSpy)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        viewModelSpy = nil
        try super.tearDownWithError()
    }
   
    //MARK: - Test Doubles
    class CreateDidViewModelSpy: CreateDidViewModelProtocol {
               
        var title = CurrentValueSubject<String, Never>("")
        var timePickerEnable = CurrentValueSubject<Bool, Never>(false)
        
        //MARK: - Input
        var setTitleCalled = false
        var setColorOfPieCalled = false
        var createCalled = false
        var setupFromDoingCalled = false
        
        var startedTime = CurrentValueSubject<Date?, Never>(nil)
        var endedTime = CurrentValueSubject<Date?, Never>(nil)
        
        func setTitle(_ title: String) {
            setTitleCalled = true
        }
        
        func setColorOfPie(_ color: UIColor) {
            setColorOfPieCalled = true
        }
        
        func setupFromDoing() {
            setupFromDoingCalled = true
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
    
    //MARK: - Tests
    func test_createDid_shouldCallViewModel() {
        //when
        sut.completeToCreateDid()
        //then
        XCTAssert(viewModelSpy.createCalled)
    }
}

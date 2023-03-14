//
//  DetaiDaylViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/01/07.
//

import XCTest
import Combine
@testable import DidTodayUIKit

class DetailDayViewModelTests: XCTestCase {
    
    //MARK: - System Under Test
    var sut: DetailDayViewModel!
    private var cancellableBag = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        fetchDidUseCaseSpy = FetchDidUseCaseSpy()
        sut = DetailDayViewModel(selected: Date())
        sut.fetchDidUseCase = fetchDidUseCaseSpy
    }
    
    override func tearDownWithError() throws {
        sut = nil
        fetchDidUseCaseSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    var fetchDidUseCaseSpy: FetchDidUseCaseSpy!
    
    final class FetchDidUseCaseSpy: FetchDidUseCase {
        
        @Published var isExecuted = false
        @Published var isExecutedFilteredToday = false
        @Published var isExecuteFiltered = false
        
        func executeFilteredByToday() async throws -> [DidTodayUIKit.Did] {
            isExecutedFilteredToday = true
            return [Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
        }
        
        func execute() async throws -> [DidTodayUIKit.Did] {
            isExecuted = true
            return [Seeds.Dids.christmasParty, Seeds.Dids.newYearParty, Seeds.Dids.todayDidMock2, Seeds.Dids.todayDidMock]
        }
        
        func executeFiltered(by date: Date) async throws -> [DidTodayUIKit.Did] {
            isExecuteFiltered = true
            return []
        }
    }
    
    //MARK: - Tests
    func test_fetchDids_shouldCallCoreDataStorage() {
        let promise = expectation(description: "Storage Be Called")
        fetchDidUseCaseSpy.$isExecuteFiltered
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        
        sut.fetchDids()
        wait(for: [promise], timeout: 2)
        XCTAssertTrue(fetchDidUseCaseSpy.isExecuteFiltered)
    }
    
    func test_selectRecently_shouldBeSelectedRecentlyButtonAndNotSelectedMuchTimeButtonWhenIsNotSelectedRecentlyButtonAndSortedByStartedDate() {
        let promise = expectation(description: "Storage Be Called")
        fetchDidUseCaseSpy.$isExecuteFiltered
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        
        sut.fetchDids()
        wait(for: [promise], timeout: 2)
        
        //given
        sut.isSelectedRecentlyButton.value = false
        //when
        sut.selectRecently()
        //then
        XCTAssertTrue(sut.isSelectedRecentlyButton.value)
        XCTAssertFalse(sut.isSelectedMuchTimeButton.value)
    }

     func test_selectMuchTime_shouldBeSelectedRecentlyButtonAndNotSelectedMuchTimeButtonWhenIsNotSelectedRecentlyButtonAndSortedByMuchTime() {
        //given
        sut.isSelectedMuchTimeButton.value = false
        //when
        sut.selectMuchTime()
        //then
        XCTAssertTrue(sut.isSelectedMuchTimeButton.value)
        XCTAssertFalse(sut.isSelectedRecentlyButton.value)
    }
}

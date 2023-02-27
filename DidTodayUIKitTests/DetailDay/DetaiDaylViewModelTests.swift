//
//  DetaiDaylViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/01/07.
//

import XCTest
@testable import DidTodayUIKit

class DetaiDaylViewModelTests: XCTestCase {
    
    //MARK: - System Under Test
    var sut: DetailDayViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    //MARK: - Tests
    func test_initalize_shouldGetTotalPiesDids() {
        ///given
        let didsMock = [Seeds.Dids.todayDidMock, Seeds.Dids.todayDidMock2]
        let expectationOfTotalItems = TotalOfDidsItemViewModel(didsMock)
        ///when
        sut = DetailDayViewModel(selected: Date(), dids: didsMock)
        ///then
        XCTAssertEqual(expectationOfTotalItems, sut.totalPieDids.value)
    }
    
    func test_initalize_shouldGetItemsList() {
        ///given
        let didsMock = [Seeds.Dids.todayDidMock, Seeds.Dids.todayDidMock2]
        let expectationOfDidItems = didsMock
            .map { DidItemViewModel($0) }
            .sorted { $0.startedTimes > $1.startedTimes }
        ///when
        sut = DetailDayViewModel(selected: Date(), dids: didsMock)
        ///then
        XCTAssertEqual(expectationOfDidItems, sut.didItemsList.value)
    }
}

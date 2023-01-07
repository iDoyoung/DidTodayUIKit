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
    func test_initalize() {
        ///given: List of Did Dummy
        let didsMock = [Seeds.Dids.todayDidMock, Seeds.Dids.todayDidMock2]
        let expectationOfTotalItems = TotalOfDidsItemViewModel(didsMock)
        let expectationOfDidItems = didsMock.map { DidItemViewModel($0) }
        ///when: init
        sut = DetailDayViewModel(dids: didsMock)
        ///then: Total Pie Dids & Did Items List
        XCTAssertEqual(expectationOfDidItems, sut.didItemsList.value)
        XCTAssertEqual(expectationOfTotalItems, sut.totalPieDids.value)
    }
}

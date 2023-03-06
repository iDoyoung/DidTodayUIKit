//
//  DidCoreDataStorageTests.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/09.
//

import XCTest
import CoreData
@testable import DidTodayUIKit

class DidCoreDataStorageTests: XCTestCase {
    //MARK: - System Under Test
    var sut: DidCoreDataStorage!
    var fetchedMockDids: [Did]?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        deleteAllDids()
        sut = DidCoreDataStorage()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func deleteAllDids() {
        fetchedMockDids?.forEach {
            let promise = expectation(description: "Should Delete Mock")
            sut.delete($0) { did, error in
                if error == nil {
                    promise.fulfill()
                } else {
                    XCTFail("Error: \(String(describing: error))")
                }
            }
            waitForExpectations(timeout: 1)
        }
        XCTAssertNil(fetchedMockDids)
    }
   
    //MARK: - Test Doubles
    let newYearMock = Seeds.Dids.newYearParty
    let todayMock = Seeds.Dids.todayDidMock
    
    //MARK: - Tests
    func test_create_shouldEqualMockWithCreation() async throws {
        let mock = Seeds.Dids.newYearParty
        let creation = try await sut.create(mock)
        XCTAssertEqual(mock, creation)
    }
    
    func test_fetchAll() async throws {
        ///given
        try await createMockData()
        ///when
        let result = try await sut.fetchDids(with: nil)
        ///then
        XCTAssertTrue(result.contains(newYearMock))
        XCTAssertTrue(result.contains(todayMock))
    }
    
    func test_fetchToday() async throws {
        ///given
        try await createMockData()
        ///when
        let result = try await sut.fetchDids(with: Date())
        ///then
        XCTAssertFalse(result.contains(newYearMock))
        XCTAssertTrue(result.contains(todayMock))
    }
    
    func createMockData() async throws {
        fetchedMockDids?.append(newYearMock)
        fetchedMockDids?.append(todayMock)
        _ = try await sut.create(newYearMock)
        _ = try await sut.create(todayMock)
    }
}

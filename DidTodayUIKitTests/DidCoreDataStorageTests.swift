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
        sut = DidCoreDataStorage()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    //MARK: - Test Doubles
    let newYearMock = Seeds.Dids.newYearParty
    let todayMock = Seeds.Dids.todayDidMock
    
    //MARK: - Tests
    func test_create_shouldEqualMockWithCreation() async throws {
        let mock = Seeds.Dids.newYearParty
        let creation = try await sut.create(mock)
        XCTAssertEqual(mock, creation)
        try await deleteDid(creation)
    }
    
    func test_fetchAll() async throws {
        ///given
        try await createMockData()
        ///when
        let result = try await sut.fetchDids(with: nil)
        ///then
        XCTAssertTrue(result.contains(newYearMock))
        XCTAssertTrue(result.contains(todayMock))
        try await deleteDid(newYearMock)
        try await deleteDid(todayMock)
    }
    
    func test_fetchToday() async throws {
        ///given
        try await createMockData()
        ///when
        let result = try await sut.fetchDids(with: Date())
        ///then
        XCTAssertFalse(result.contains(newYearMock))
        XCTAssertTrue(result.contains(todayMock))
        try await deleteDid(newYearMock)
        try await deleteDid(todayMock)
    }
    
    func test_delete() async throws {
        try await createMockData()
        try await sut.delete(newYearMock)
        try await sut.delete(todayMock)
        let fetched = try await sut.fetchDids(with: nil)
        XCTAssertFalse(fetched.contains(newYearMock))
        XCTAssertFalse(fetched.contains(todayMock))
    }
    
    func createMockData() async throws {
        fetchedMockDids?.append(newYearMock)
        fetchedMockDids?.append(todayMock)
        try await sut.create(newYearMock)
        try await sut.create(todayMock)
    }
    
    func deleteDid(_ did: Did) async throws {
        try await sut.delete(did)
    }
}

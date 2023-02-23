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
   
    //MARK: - Tests
    func test_create_shouldEqualMockWithCreation() async throws {
        let mock = Seeds.Dids.newYearParty
        let creation = try await sut.create(mock)
        XCTAssertEqual(mock, creation)
    }
}

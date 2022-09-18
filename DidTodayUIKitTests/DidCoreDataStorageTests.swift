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
        fetchMockDids()
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
    func fetchMockDids() {
        let promise = expectation(description: "Should Fetch did mocks")
        sut.fetchDids { [weak self] dids, error in
            if error == nil {
                self?.fetchedMockDids = dids
                promise.fulfill()
            } else {
                XCTFail("Error: \(String(describing: error))")
            }
        }
        wait(for: [promise], timeout: 1)
    }
    
    //MARK: - Tests
    func test_create_shouldCotainAddedMock_whenFetched() {
        //given
        let mock = Seeds.Dids.mock
        let promise = expectation(description: "")
        sut.create(mock) { did, error in
            if error == nil {
                promise.fulfill()
            } else {
                XCTFail("Error: \(String(describing: error))")
            }
        }
        wait(for: [promise], timeout: 1)
        //when
        fetchMockDids()
        //then
        guard let fetchedMockDids = fetchedMockDids else { return }
        XCTAssert(fetchedMockDids.contains(mock))
    }
}

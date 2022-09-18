//
//  MainViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/15.
//

import XCTest
@testable import DidTodayUIKit

class MainViewModelTests: XCTestCase {
    //MARK: - System Under Test
    var sut: MainViewModel!
    var didsCoreDataStorageSpy: DidsCoreDataStorageSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        didsCoreDataStorageSpy = DidsCoreDataStorageSpy()
        sut = MainViewModel(didCoreDataStorage: didsCoreDataStorageSpy)
    }
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    final class DidsCoreDataStorageSpy: DidCoreDataStorable {
        var dids: [Did]?
        var createDidCalled = false
        var fetchDidsCalled = false
        var updateDidCalled = false
        var deleteDidCalled = false
        
        func create(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            createDidCalled = true
        }
        func fetchDids(completion: @escaping ([Did], CoreDataStoreError?) -> Void) {
            fetchDidsCalled = true
            guard let dids = dids else {
                return
            }
            completion(dids, nil)
        }
        func update(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            updateDidCalled = true
        }
        func delete(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            deleteDidCalled = true
        }
    }
    
    //MARK: - Tests
    func test_fetchDids_shouldCallDidsCoreDataStorageAndGetOutputFetchedDids() {
        //given
        let mockDids = [Seeds.Dids.mock]
        let expectation = mockDids.map { MainDidItemsViewModel($0) }
        didsCoreDataStorageSpy.dids = mockDids
        //when
        sut.fetchDids()
        //then
        XCTAssert(didsCoreDataStorageSpy.fetchDidsCalled)
        XCTAssertEqual(expectation, sut.fetchedDids)
    }
}

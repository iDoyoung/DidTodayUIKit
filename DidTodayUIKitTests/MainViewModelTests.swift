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

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainViewModel()
    }
    override func tearDownWithError() throws {
        sut = MainViewModel()
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    final class DidsCoreDataStorageSpy: DidCoreDataStorable {
        var createDidCalled = false
        var fetchDidsCalled = false
        var updateDidCalled = false
        var deleteDidCalled = false
        
        func create(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void) {
            createDidCalled = true
        }
        func fetchDids(completion: @escaping ([DidItem], CoreDataStoreError?) -> Void) {
            fetchDidsCalled = true
        }
        func update(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void) {
            updateDidCalled = true
        }
        func delete(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void) {
            deleteDidCalled = true
        }
    }
    
    //MARK: - Tests
    func test_fetchDids_shouldCallDidsCoreDataStorage() {
        //given
        let didsCoreDataStorageSpy = DidsCoreDataStorageSpy()
        sut.didcCoreDataStorage = didsCoreDataStorageSpy
        //when
        sut.fetchDids()
        //then
        XCTAssert(didsCoreDataStorageSpy.fetchDidsCalled)
    }
}

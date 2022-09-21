//
//  CreateDidViewModelTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2022/09/21.
//

import XCTest
@testable import DidTodayUIKit

class CreateDidViewModelTests: XCTestCase {
    //MARK: - Sytem Under Test
    var sut: CreateDidViewModel!
    var didCoreDataStorageSpy: DidCoreDataStorageSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        didCoreDataStorageSpy = DidCoreDataStorageSpy()
        sut = CreateDidViewModel(didCoreDataStorage: didCoreDataStorageSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        didCoreDataStorageSpy = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    final class DidCoreDataStorageSpy: DidCoreDataStorable {
        var createDidCalled = false
        var fetchDidsCalled = false
        var updateDidCalled = false
        var deleteDidCalled = false
        
        func create(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            createDidCalled = true
        }
        func fetchDids(completion: @escaping ([Did], CoreDataStoreError?) -> Void) {
            fetchDidsCalled = true
        }
        func update(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            updateDidCalled = true
        }
        func delete(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
            deleteDidCalled = true
        }
    }
    
    //MARK: - Tests
    func test_create_shouldCallDidCoreDataStorage_whenStartedTimeAndTitleAndColorAreNotNil() {
        //given
        sut.startedTime = Date()
        sut.color = .blue
        sut.title = ""
        //when
        sut.createDid { _ in }
        //then
        XCTAssert(didCoreDataStorageSpy.createDidCalled)
    }
    func test_create_shouldNotCallCoreDataStorage_whenStartedTimeOrTitleOrColorIsNil() {
        //given
        //when
        sut.createDid { _ in }
        //then
        XCTAssert(!didCoreDataStorageSpy.createDidCalled)
    }
}

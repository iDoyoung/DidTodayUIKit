//
//  DidUseCaseTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/03/05.
//

import XCTest
@testable import DidTodayUIKit

final class FetchDidUseCaseTests: XCTestCase {

    //MARK: - System under tests
    var sut: FetchDidUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultFetchDidUseCase(storage: didCoreDataStorageSpy)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    //MARK: - Test Doubles
    let didCoreDataStorageSpy = DidCoreDataStorageSpy()
    
    static let mockDids = [
        Did(started: Seeds.MockDate.noon!, finished: Seeds.MockDate.midnight!, content: "Content1", color: .init(red: 0, green: 0, blue: 0, alpha: 0)),
        Did(started: Seeds.MockDate.noon!, finished: Seeds.MockDate.midnight!, content: "Content2", color: .init(red: 0, green: 0, blue: 0, alpha: 0))
   ]
    
    final class DidCoreDataStorageSpy: DidCoreDataStorable {
        
        var created = [Did]()
        
        var createCalled = false
        var fetchDidsCalled = false
        var updateCalled = false
        var deleteCalled = false
        
        func create(_ did: DidTodayUIKit.Did) async throws -> DidTodayUIKit.Did {
            created.append(did)
            createCalled = true
            return did
        }
        
        func fetchDids(with filtering: Date?) async throws -> [DidTodayUIKit.Did] {
            fetchDidsCalled = true
            return mockDids
        }
        
        func update(_ did: DidTodayUIKit.Did, completion: @escaping (DidTodayUIKit.Did, DidTodayUIKit.CoreDataStoreError?) -> Void) {
            updateCalled = true
        }
        
        func delete(_ did: DidTodayUIKit.Did) async throws -> DidTodayUIKit.Did {
            deleteCalled = true
            return did
        }
    }
    
    //MARK: - Tests
    func test_execute_shouldCallStorageAndGetDids() async throws {
        let loaded = try await sut.execute()
        XCTAssertTrue(loaded.count == 2)
        XCTAssertTrue(didCoreDataStorageSpy.fetchDidsCalled)
    }
    
    func test_executeFilteredByToday() async throws {
        let _ = try await sut.executeFilteredByToday()
        XCTAssertTrue(didCoreDataStorageSpy.fetchDidsCalled)
    }
}

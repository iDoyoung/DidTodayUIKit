//
//  DeleteUseCaseTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/03/13.
//

import XCTest
@testable import DidTodayUIKit

final class DeleteUseCaseTests: XCTestCase {

    //MARK: - System Under Tests
    var sut: DeleteDidUseCase!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DefaultDeleteDidUseCase(storage: didCoreDataStorageSpy)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test Doubles
    let didCoreDataStorageSpy = DidCoreDataStorageSpy()
    
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
        
        func fetchDids(with filtering: Date?) async throws -> [DidTodayUIKit.Did]  {
            fetchDidsCalled = true
            return []
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
    func test_useCase_shouldCallStorage() async throws {
        try await sut.execute(with: Seeds.Dids.christmasParty)
        XCTAssertTrue(didCoreDataStorageSpy.deleteCalled)
    }
}

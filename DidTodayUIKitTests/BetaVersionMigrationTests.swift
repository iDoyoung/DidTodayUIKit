//
//  BetaVersionMigrationTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/01/12.
//

import XCTest
import Combine
@testable import DidTodayUIKit

final class BetaVersionMigrationTests: XCTestCase {

    //MARK: - System Under Tests
    var sut: BetaVersionMigration!
    var didCoreDataStorageSpy = DidCoreDataStorageSpy()
    private var cancellableBag = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        sut = BetaVersionMigration()
        sut.coreDataStorage = didCoreDataStorageSpy
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test Doubles
    final class DidCoreDataStorageSpy: DidCoreDataStorable {
        
        var created = [Did]()
        
        @Published var createCalled = false
        var fetchDidsCalled = false
        var updateCalled = false
        var deleteCalled = false
        
        func create(_ did: DidTodayUIKit.Did) async throws -> DidTodayUIKit.Did {
            created.append(did)
            createCalled = true
            return did
        }
        
        func fetchDids() async throws -> [DidTodayUIKit.Did] {
            return []
        }
        
        func fetchDids(completion: @escaping ([DidTodayUIKit.Did], DidTodayUIKit.CoreDataStoreError?) -> Void) {
            fetchDidsCalled = true
        }
        
        func update(_ did: DidTodayUIKit.Did, completion: @escaping (DidTodayUIKit.Did, DidTodayUIKit.CoreDataStoreError?) -> Void) {
            updateCalled = true
        }
        
        func delete(_ did: DidTodayUIKit.Did, completion: @escaping (DidTodayUIKit.Did, DidTodayUIKit.CoreDataStoreError?) -> Void) {
            deleteCalled = true
        }
    }
    
    //MARK: - Tests
    
    func test_migrate_whenHavePreviousDidDataIfLaunchedBefore() {
        ///given
        givePreviousDidDummy()
        let promise = expectation(description: "Should Call Core Data")
        sut.launchedBefore = true
        sut.isMigratedToCoreData = false
        
        didCoreDataStorageSpy.$createCalled
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        ///when
        sut.migrateUserDefaultToCoreData()
        wait(for: [promise], timeout: 2)
        ///then
        XCTAssert(didCoreDataStorageSpy.createCalled)
        XCTAssertEqual(self.didCoreDataStorageSpy.created.count, 1)
        XCTAssertEqual(self.didCoreDataStorageSpy.created[0].content, "Test")
        XCTAssertNil(UserDefaults.standard.object(forKey: PreviousVersionModel().today))
    }
    
    func test_migrate_whenHaveOldDidDataIfNotLaunchedBefore() {
        ///given
        givePreviousOldDidDummy()
        let promise = expectation(description: "Should Call Core Data")
        sut.launchedBefore = false
        sut.isMigratedToCoreData = false
        
        didCoreDataStorageSpy.$createCalled
            .sink { isCalled in
                if isCalled {
                    promise.fulfill()
                }
            }
            .store(in: &cancellableBag)
        ///when
        sut.migrateUserDefaultToCoreData()
        wait(for: [promise], timeout: 2)
        ///then
        XCTAssert(didCoreDataStorageSpy.createCalled)
        XCTAssertEqual(didCoreDataStorageSpy.created.count, 1)
        XCTAssertEqual(didCoreDataStorageSpy.created[0].content, "Test")
        XCTAssertNil(UserDefaults.standard.object(forKey: PreviousVersionModel().today))
    }
    
    func givePreviousDidDummy() {
        let defaults = UserDefaults.standard
        let day = PreviousVersionModel().today
        let encoder = JSONEncoder()
        let dids = [PreviousVersionModel.Did(id: 0,
                                             did: "Test",
                                             start: "07:07",
                                             finish: "16:16",
                                             colour: .green)]
        if let encoded = try? encoder.encode(dids) {
            defaults.set(encoded, forKey: day)
        }
    }
    
    func givePreviousOldDidDummy() {
        let defaults = UserDefaults.standard
        let day = PreviousVersionModel().today
        let encoder = JSONEncoder()
        let dids = [PreviousVersionModel.OldDid(did: "Test",
                                                start: "07:07",
                                                finish: "16:07",
                                                colour: .green)]
        if let encoded = try? encoder.encode(dids) {
            defaults.set(encoded, forKey: day)
        }
    }
}

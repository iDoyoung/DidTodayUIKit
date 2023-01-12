//
//  BetaVersionMigrationTests.swift
//  DidTodayUIKitTests
//
//  Created by Doyoung on 2023/01/12.
//

import XCTest
@testable import DidTodayUIKit

final class BetaVersionMigrationTests: XCTestCase {

    //MARK: - System Under Tests
    var sut: BetaVersionMigration!
    var didCoreDataStorageSpy = DidCoreDataStorageSpy()
    
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
        
        var createCalled = false
        var fetchDidsCalled = false
        var updateCalled = false
        var deleteCalled = false
        
        func create(_ did: DidTodayUIKit.Did, completion: @escaping (DidTodayUIKit.Did, DidTodayUIKit.CoreDataStoreError?) -> Void) {
            created.append(did)
            createCalled = true
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
        let expectaion = UserDefaults.standard.object(forKey: PreviousVersionModel().today)
        ///given
        givePreviousDidDummy()
        sut.launchedBefore = true
        ///when
        sut.migrateUserDefaultToCoreData()
        ///then
        XCTAssert(didCoreDataStorageSpy.createCalled)
        XCTAssertEqual(didCoreDataStorageSpy.created.count, 1)
        XCTAssertEqual(didCoreDataStorageSpy.created[0].content, "Test")
        XCTAssertNil(expectaion)
    }
    
    func test_migrate_whenHaveOldDidDataIfNotLaunchedBefore() {
        
        let expectation = UserDefaults.standard.object(forKey: PreviousVersionModel().today)
        ///given
        givePreviousOldDidDummy()
        sut.launchedBefore = nil
        ///when
        sut.migrateUserDefaultToCoreData()
        ///then
        XCTAssert(didCoreDataStorageSpy.createCalled)
        XCTAssertEqual(didCoreDataStorageSpy.created.count, 1)
        XCTAssertEqual(didCoreDataStorageSpy.created[0].content, "Test")
        XCTAssertNil(expectation)
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

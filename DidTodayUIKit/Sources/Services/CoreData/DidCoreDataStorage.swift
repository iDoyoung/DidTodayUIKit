//
//  DidCoreDataStorage.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/08.
//

import CoreData

enum CoreDataStoreError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

protocol DidCoreDataStorable {
    @discardableResult func create(_ did: Did) async throws -> Did
    func fetchDids(with filtering: Date?) async throws -> [Did]
    func update(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void)
    @discardableResult func delete(_ did: Did) async throws -> Did
}

final class DidCoreDataStorage: DidCoreDataStorable {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    @discardableResult func create(_ did: Did) async throws -> Did {
        return try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                let managedDid = ManagedDidItem(context: context)
                managedDid.fromDidItem(did)
                if context.hasChanges {
                    do {
                        try context.save()
                        continuation.resume(returning: did)
                    } catch let error {
                        continuation.resume(throwing: CoreDataStoreError.saveError(error))
                    }
                }
            }
        }
    }
    
    func fetchDids(with filtering: Date?) async throws -> [Did] {
        return try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                do {
                    let request = ManagedDidItem.fetchRequest()
                    if let filtering {
                        let calendar = Calendar.current
                        let startDate = calendar.startOfDay(for: filtering)
                        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                        request.predicate = NSPredicate(format: "finished>=%@ AND finished<=%@", startDate as NSDate, endDate as NSDate)
                    }
                    let result = try context.fetch(request)
                    let fetched = result.map { $0.toDidItem() }
                    continuation.resume(returning: fetched)
                } catch let error {
                    continuation.resume(throwing: CoreDataStoreError.readError(error))
                }
            }
        }
    }
    
    func update(_ did: Did, completion: @escaping (Did, CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let request = ManagedDidItem.fetchRequest()
                request.predicate = NSPredicate(format: "identifier==%@", did.id as CVarArg)
                let result = try context.fetch(request)
                if let manangedDid = result.first {
                    manangedDid.fromDidItem(did)
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch let error {
                            completion(did, CoreDataStoreError.saveError(error))
                        }
                    }
                }
            } catch {
                completion(did, CoreDataStoreError.readError(error))
            }
        }
    }
    
    @discardableResult func delete(_ did: Did) async throws -> Did {
        return try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                do {
                    let request = ManagedDidItem.fetchRequest()
                    request.predicate = NSPredicate(format: "identifier==%@", did.id as CVarArg)
                    let result = try context.fetch(request)
                    if let managedDid = result.first {
                        context.delete(managedDid)
                        do {
                            try context.save()
                            continuation.resume(returning: did)
                        } catch let error {
                            continuation.resume(throwing: CoreDataStoreError.deleteError(error))
                        }
                    }
                } catch let error {
                    continuation.resume(throwing: CoreDataStoreError.readError(error))
                }
            }
        }
    }
}

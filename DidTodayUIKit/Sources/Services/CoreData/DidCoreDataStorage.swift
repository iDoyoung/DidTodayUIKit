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
    func create(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void)
    func fetchDids(completion: @escaping ([DidItem], CoreDataStoreError?) -> Void)
    func update(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void)
    func delete(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void)
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
    
    func create(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let managedDid = ManagedDidItem(context: context)
            managedDid.fromDidItem(did, context: context)
            if context.hasChanges {
                do {
                    try context.save()
                    completion(did, nil)
                } catch let error {
                    completion(did, CoreDataStoreError.saveError(error))
                }
            }
        }
    }
    func fetchDids(completion: @escaping ([DidItem], CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let request = ManagedDidItem.fetchRequest()
                let result = try context.fetch(request)
                let fetched = result.map { $0.toDidItem() }
                completion(fetched, nil)
            } catch let error {
                completion([], CoreDataStoreError.saveError(error))
            }
        }
    }
    func update(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let request = ManagedDidItem.fetchRequest()
                request.predicate = NSPredicate(format: "identifier==%@", did.id as CVarArg)
                let result = try context.fetch(request)
                if let manangedDid = result.first {
                    manangedDid.fromDidItem(did, context: context)
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
    func delete(_ did: DidItem, completion: @escaping (DidItem, CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let request = ManagedDidItem.fetchRequest()
                request.predicate = NSPredicate(format: "identifier==%@", did.id as CVarArg)
                let result = try context.fetch(request)
                if let managedDid = result.first {
                    context.delete(managedDid)
                    do {
                        try context.save()
                    } catch let error {
                        completion(did, CoreDataStoreError.deleteError(error))
                    }
                }
            } catch let error {
                completion(did, CoreDataStoreError.readError(error))
            }
        }
    }
}

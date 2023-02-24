//
//  PreviousVersionHandler.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/12.
//

import Foundation

final class BetaVersionMigration {
    
    let defaults = UserDefaults.standard
    var legacy: PreviousVersionModel = PreviousVersionModel.shared
    var coreDataStorage: DidCoreDataStorable = DidCoreDataStorage()
    var launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    var isMigratedToCoreData = UserDefaults.standard.bool(forKey: "migration-to-core-data-first")
    
    func migrateUserDefaultToCoreData() async throws {
        guard !isMigratedToCoreData else {
            #if DEBUG
            print("Is not first launch after updated version 2")
            #endif
            return
        }
        
        if launchedBefore {
            #if DEBUG
            print("Second updating")
            #endif
            try await migratePrevious()
            defaults.removeObject(forKey: "launchedBefore")
        } else {
            #if DEBUG
            print("First launching, Or Never updated before")
            #endif
            try await migrateOld()
        }
        defaults.set(true, forKey: "migration-to-core-data-first")
    }
    
    private func migratePrevious() async throws {
        let dateKeys = defaults.dictionaryRepresentation().keys
            .filter { $0.prefix(2) == "20" }
        
        for key in dateKeys {
            if let dids: [PreviousVersionModel.Did] = legacy.loadLastDate(date: key) {
                for did in dids {
                    guard let startedDate = legacy.formatStringToDate(key + did.start),
                          let finsihedDate = legacy.formatStringToDate(key + did.finish) else { return }
                    
                    let output = Did(started: startedDate,
                                     finished: finsihedDate,
                                     content: did.did,
                                     color: Did.PieColor(red: Float(did.colour.getRedOfRGB()),
                                                         green: Float(did.colour.getGreenOfRGB()),
                                                         blue: Float(did.colour.getBlueRGB()),
                                                         alpha: 1))
                    try await coreDataStorage.create(output)
                    defaults.removeObject(forKey: key)
                }
            }
        }
    }
    
    ///- Tag: Previous Old Did -> Did Of Core Data
    private func migrateOld() async throws {
        let dateKeys = defaults.dictionaryRepresentation().keys
            .filter { $0.prefix(2) == "20" }
        
        for key in dateKeys {
            guard let dids: [PreviousVersionModel.OldDid] = legacy.loadLastDate(date: key) else { return }
            
            for did in dids {
                guard let startedDate = legacy.formatStringToDate(key + did.start),
                      let finsihedDate = legacy.formatStringToDate(key + did.finish) else { return }
                
                let output = Did(started: startedDate,
                                 finished: finsihedDate,
                                 content: did.did,
                                 color: Did.PieColor(red: Float(did.colour.getRedOfRGB()),
                                                     green: Float(did.colour.getGreenOfRGB()),
                                                     blue: Float(did.colour.getBlueRGB()),
                                                     alpha: 1))
                try await coreDataStorage.create(output)
                defaults.removeObject(forKey: key)
            }
        }
    }
   
    deinit {
#if DEBUG
        print("Success update")
#endif
    }
}

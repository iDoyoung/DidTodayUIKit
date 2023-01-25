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
    
    func migrateUserDefaultToCoreData() {
        if !isMigratedToCoreData {
            if launchedBefore == true {
#if DEBUG
                print("Second updating")
#endif
                migratePrevious { [weak self] in
                    self?.defaults.removeObject(forKey: "launchedBefore")
                    self?.defaults.set(true, forKey: "migration-to-core-data-first")
                }
            } else {
#if DEBUG
                print("First launching, Or Never updated before")
#endif
                migrateOld { [weak self] in
                    self?.defaults.set(true, forKey: "migration-to-core-data-first")
                }
            }
        }
    }
    
    private func migratePrevious(completion: @escaping () -> Void) {
        let dateKeys = defaults.dictionaryRepresentation().keys
            .filter { $0.prefix(2) == "20" }
        
        let taskGroup = DispatchGroup()
        for key in dateKeys {
            if let dids: [PreviousVersionModel.Did] = legacy.loadLastDate(date: key) {
                dids.forEach {
                    let startedDateString = key + $0.start
                    let finishedDateString = key + $0.finish
                    
                    guard let startedDate = legacy.formatStringToDate(startedDateString),
                          let finsihedDate = legacy.formatStringToDate(finishedDateString) else { return }
                    let title = $0.did
                    let red = Float($0.colour.getRedOfRGB())
                    let green = Float($0.colour.getGreenOfRGB())
                    let blue = Float($0.colour.getBlueRGB())
                    let output = Did(started: startedDate, finished: finsihedDate, content: title, color: Did.PieColor(red: red,
                                                                                                                       green: green,
                                                                                                                       blue: blue,
                                                                                                                       alpha: 1))
                    taskGroup.enter()
                    coreDataStorage.create(output) { [weak self] did, error in
                        assert(error == nil, "Unexpected Error: Appear error when creation in Core Data")
                        self?.defaults.removeObject(forKey: key)
                        taskGroup.leave()
                    }
                }
            }
        }
        taskGroup.notify(queue: .global()) { completion() }
    }
    
    ///- Tag: Previous Old Did -> Did Of Core Data
    private func migrateOld(completion: @escaping () -> Void) {
        let dateKeys = defaults.dictionaryRepresentation().keys.filter({
            $0.prefix(2) == "20"
        })
        let taskGroup = DispatchGroup()
        
        for key in dateKeys {
            guard let dids: [PreviousVersionModel.OldDid] = legacy.loadLastDate(date: key) else { return }
            
            dids.forEach {
                let startedDateString = key + $0.start
                let finishedDateString = key + $0.finish
                
                guard let startedDate = legacy.formatStringToDate(startedDateString),
                      let finsihedDate = legacy.formatStringToDate(finishedDateString) else { return }
                let title = $0.did
                let red = Float($0.colour.getRedOfRGB())
                let green = Float($0.colour.getGreenOfRGB())
                let blue = Float($0.colour.getBlueRGB())
                let output = Did(started: startedDate, finished: finsihedDate, content: title, color: Did.PieColor(red: red,
                                                                                                                   green: green,
                                                                                                                   blue: blue,
                                                                                                                   alpha: 1))
                
                taskGroup.enter()
                coreDataStorage.create(output) { [weak self] did, error in
                    assert(error == nil, "Unexpected Error: Appear error when creation in Core Data")
                    self?.defaults.removeObject(forKey: key)
                    taskGroup.leave()
                }
            }
        }
        taskGroup.notify(queue: .global()) { completion() }
    }
    
    deinit {
#if DEBUG
        print("Success update")
#endif
    }
}

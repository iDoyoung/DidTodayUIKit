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
    lazy var launchedBefore: Bool? = defaults.bool(forKey: "launchedBefore")
    
    func migrateUserDefaultToCoreData() {
        if let theLaunchedBefore = launchedBefore, theLaunchedBefore {
            #if DEBUG
            print("Try Migrate")
            #endif
            migratePrevious()
            defaults.removeObject(forKey: "launchedBefore")
        } else {
            migrateOld()
        }
    }
    
    private func migratePrevious() {
            let dateKeys = defaults.dictionaryRepresentation().keys
                .filter { $0.prefix(2) == "20" }
            
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
                        coreDataStorage.create(output) { did, error in
                        #if DEBUG
                            if error == nil {
                                print("Success save \(did.content)")
                            } else {
                                print("\(String(describing: error))")
                            }
                        #endif
                        }
                    }
                }
                defaults.removeObject(forKey: key)
            }
    }
    
    ///- Tag: Previous Old Did -> Did Of Core Data
    private func migrateOld() {
        let dateKeys = defaults.dictionaryRepresentation().keys.filter({
            $0.prefix(2) == "20"
        })
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
                coreDataStorage.create(output) { did, error in
                    #if DEBUG
                    if error == nil {
                        print("Success save \(did.content)")
                    } else {
                        print("\(String(describing: error))")
                    }
                    #endif
                }
            }
            defaults.removeObject(forKey: key)
        }
    }
    
    deinit {
        #if DEBUG
        print("Success update")
        #endif
    }
}

//
//  ViewModel.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//
import UIKit
import Foundation

class DidViewModel {
    
    var model = Model.shared
    
    
    var dids: [Model.Did] {
        model.dids
    }
    
    var hours: Int {
        model.hour
    }

    var minutes: Int {
        model.minute
    }
    
    var currentTime: Int {
        model.currentTime
    }
    
    func timeFormat(saved about: String) -> Double {
        let hour: Int = model.formatTimeHours(time: about)
        let minute: Int = model.formatTimeMinutes(time: about)
        
        return Double(hour + minute)
    }
    
//    func minutesData(saved about: String) -> Int {
//        model.formatTimeMinutes(time: about)
//    }
    
    func loadToday() {
        model.loadToday()
    }
    
    func save(did thing: String, at start: String, to finish: String, look colour: UIColor) {
        model.setData(thing: thing, start: start, finish: finish, colour: colour)
    }
    
//    func add(did thing: String, at start: String, to finish: String, colour: String) {
//        model.addDid(thing: thing, start: start, finish: finish)
//    }
    
    
}

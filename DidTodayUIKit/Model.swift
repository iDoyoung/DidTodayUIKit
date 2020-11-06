//
//  Model.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//

import Foundation
import UIKit

class Model {
    
    static let shared = Model()
    
    var dids: [Did] = []
    
    
    
    struct Color : Codable {
        var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0

        var uiColor : UIColor {
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }

        init(uiColor : UIColor) {
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        }
    }
    
    struct Did: Codable {
        
        private enum CodingKeys: String, CodingKey { case did, start, finish, colour }
        
        var did: String
        var start: String
        var finish: String
        var colour: UIColor
        
        init(did: String, start: String, finish: String, colour: UIColor) {
            self.did = did
            self.start = start
            self.finish = finish
            self.colour = colour
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            did = try container.decode(String.self, forKey: .did)
            start = try container.decode(String.self, forKey: .start)
            finish = try container.decode(String.self, forKey: .finish)
            colour = try container.decode(Color.self, forKey: .colour).uiColor
        }
        
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(did, forKey: .did)
            try container.encode(start, forKey: .start)
            try container.encode(finish, forKey: .finish)
            try container.encode(Color(uiColor: colour), forKey: .colour)
        }
    }
    
    

    
    let date = Date()
    
    let dateFormatter = DateFormatter()
    
    var today: String {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
    var hour: Int {
        dateFormatter.dateFormat = "HH:mm"
        return Calendar.current.component(.hour, from: Date())
    }
    
    var minute: Int {
        dateFormatter.dateFormat = "HH.mm"
        return Calendar.current.component(.minute, from: Date())
    }
    
    var currentTime: Int {
        (hour * 60) + minute
    }
    
    func formatTime(time: String) -> Date {
        dateFormatter.dateFormat = "HH:mm"
        let times = dateFormatter.date(from: time)!
        return times
    }
    
    func formatTimeHours(time: String) -> Int {
        dateFormatter.dateFormat = "HH:mm"
        
        let times = dateFormatter.date(from: time)
        
        guard let unwrap = times else {
            return 0
        }
        let hour = Calendar.current.component(.hour, from: unwrap)*60
        return hour
    }
    
    
    func formatTimeMinutes(time: String) -> Int {
        dateFormatter.dateFormat = "HH:mm"
        
        let times = dateFormatter.date(from: time)
        guard let unwrap = times else {
            return 0
        }
        let minutes = Calendar.current.component(.minute, from: unwrap)
        return minutes
    }
    
    let defaults = UserDefaults.standard

    func setData(thing: String, start: String, finish: String, colour: UIColor) {
        
        let encoder = JSONEncoder()
        
        let newDid = Did(did: thing, start: start, finish: finish, colour: colour)
        dids.append(newDid)
        if let encoded = try? encoder.encode(dids) {
        defaults.set(encoded, forKey: today)
            print("Success save data")
            print(newDid)
        }
    }
    
    
    func loadToday() {
        if let savedDid = defaults.object(forKey: today) as? Data {
            let decoder = JSONDecoder()
            if let loadedDids = try? decoder.decode([Did].self, from: savedDid) {
                dids = loadedDids
                print("success load data")
                print(dids)
            }
        }
    }
    
    func loadLastDate(date: String) {
        if let savedDid = defaults.object(forKey: date) as? Data {
            let decoder = JSONDecoder()
            if let loadedDids = try? decoder.decode([Did].self, from: savedDid) {
                dids = loadedDids
                print("success load data")
                print(dids)
            }
        }
    }
   
}

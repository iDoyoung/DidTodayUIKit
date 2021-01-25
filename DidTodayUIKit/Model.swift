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

    //MARK: - Users Defaults Data
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
        
        private enum CodingKeys: String, CodingKey { case id, did, start, finish, colour }
        var id : Int
        var did: String
        var start: String
        var finish: String
        var colour: UIColor
        
        init(id: Int, did: String, start: String, finish: String, colour: UIColor) {
            self.id = id
            self.did = did
            self.start = start
            self.finish = finish
            self.colour = colour
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            did = try container.decode(String.self, forKey: .did)
            start = try container.decode(String.self, forKey: .start)
            finish = try container.decode(String.self, forKey: .finish)
            colour = try container.decode(Color.self, forKey: .colour).uiColor
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(did, forKey: .did)
            try container.encode(start, forKey: .start)
            try container.encode(finish, forKey: .finish)
            try container.encode(Color(uiColor: colour), forKey: .colour)
        }
    }
    
    struct OldDid: Codable {
        
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
    
    
    let defaults = UserDefaults.standard

    var savedDays: [Date] = []
    
    func printKey() {
        let savedDate = defaults.dictionaryRepresentation().keys.filter({ $0.prefix(2) == "20" })
        print(savedDate)
        for day in savedDate {
            dateFormatter.dateFormat = "yyyyMMdd"
            let savedDate = dateFormatter.date(from: day)!
                savedDays.append(savedDate)
        }
    }
    
    func setData(thing: String, start: String, finish: String, colour: UIColor, day: String) {
        let encoder = JSONEncoder()
        let newDid = Did(id: dids.count, did: thing, start: start, finish: finish, colour: colour)
        dids.append(newDid)
        if let encoded = try? encoder.encode(dids) {
        defaults.set(encoded, forKey: day)
        }
    }
    
    func undoPie() {
        let end = dids.endIndex - 1
        dids.remove(at: end)
        if dids.isEmpty {
            defaults.removeObject(forKey: today)
        } else {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(dids) {
                defaults.set(encoded, forKey: today)
            }
        }
    }
    
    func loadToday() {
        dids = [Did]()
        if let savedDid = defaults.object(forKey: today) as? Data {
            let decoder = JSONDecoder()
            if let loadedDids = try? decoder.decode([Did].self, from: savedDid) {
                dids = loadedDids
                print("success load data")
            }
        }
    }
    
    
    func loadLastDate(date: String) {
        dids = [Did]()
        if let savedDid = defaults.object(forKey: date) as? Data {
            let decoder = JSONDecoder()
            if let loadedDids = try? decoder.decode([Did].self, from: savedDid) {
                dids = loadedDids
                print("success load data")
            }
        }
    }
    
    func updateData(date: String) {
        if let savedDid = defaults.object(forKey: date) as? Data {
            let decoder = JSONDecoder()
            if let loadedDids = try? decoder.decode([OldDid].self, from: savedDid) {
                var id = 0
                dids = [Did]()
                for index in loadedDids {
                    let newDid = Did(id: id, did: index.did, start: index.start, finish: index.finish, colour: index.colour)
                    dids.append(newDid)
                    id += 1
                }
            }
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(dids) {
            defaults.set(encoded, forKey: date)
        }
    }
    
    struct Doing: Codable {
        private enum CodingKeys: String, CodingKey { case doing, startTime, colour, date }
        
        var doing: String
        var startTime: String
        var colour: UIColor
        var date: String
        
        init(doing: String, startTime: String, colour: UIColor, date: String) {
            self.doing = doing
            self.startTime = startTime
            self.colour = colour
            self.date = date
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            doing = try container.decode(String.self, forKey: .doing)
            startTime = try container.decode(String.self, forKey: .startTime)
            colour = try container.decode(Color.self, forKey: .colour).uiColor
            date = try container.decode(String.self, forKey: .date)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(doing, forKey: .doing)
            try container.encode(startTime, forKey: .startTime)
            try container.encode(Color(uiColor: colour), forKey: .colour)
            try container.encode(date, forKey: .date)
        }
    }
    
    var startNow: [Doing] = []

    func saveDoing(when: String, what: String, color: UIColor) {
        let encoder = JSONEncoder()
        let doingNow = Doing(doing: what, startTime: when, colour: color, date: today)
        startNow.append(doingNow)
        if let encoded = try? encoder.encode(startNow) {
            defaults.set(encoded, forKey: "Doing")
        }
    }
    
    func loadDoing() {
        startNow = [Doing]()
        if let loaded = defaults.object(forKey: "Doing") as? Data {
            let decorder = JSONDecoder()
            if let loadDoing = try? decorder.decode([Doing].self, from: loaded) {
                print(loadDoing)
                startNow = loadDoing
            }
        }
    }
    
    func deleteDoing() {
        defaults.removeObject(forKey: "Doing")
        startNow = []
    }
    
    

    //MARK: - Date & Time
    let date = Date()
    
    let dateFormatter = DateFormatter()
    
    var today: String {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
    var todayDate: String {
        dateFormatter.dateFormat = "MMMM d"
        let todayMMDD = dateFormatter.string(from: date)
        if Locale.current.languageCode == "ko"{
            return todayMMDD + "일"
        } else {
            return todayMMDD
        }
    }
    
    var now: String {
        dateFormatter.dateFormat = "HH:mm"
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
    
    var currentToMinutes: Int {
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
    
    func dateToString(time: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: time)
        return time
    }
}

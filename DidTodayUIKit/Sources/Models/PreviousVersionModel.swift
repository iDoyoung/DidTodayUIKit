//
//  Model.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//

import UIKit

class PreviousVersionModel {
    static let shared = PreviousVersionModel()

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
    
    func loadLastDate(date: String) -> [Did]? {
        let decoder = JSONDecoder()
        guard let savedDid = defaults.object(forKey: date) as? Data,
              let loadedDids = try? decoder.decode([Did].self, from: savedDid) else { return nil}
        return loadedDids
    }
    
    func loadLastDate(date: String) -> [OldDid]? {
        let decoder = JSONDecoder()
        guard let savedDid = defaults.object(forKey: date) as? Data,
              let loadedDids = try? decoder.decode([OldDid].self, from: savedDid) else { return nil }
        return loadedDids
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
    
    func formatStringToDate(_ input: String) -> Date? {
        dateFormatter.dateFormat = "yyyyMMddHH:mm"
        let date = dateFormatter.date(from: input)
        return date
    }
    
    func dateToString(time: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: time)
        return time
    }
    
    deinit {
        #if DEBUG
        print("Deinit Previous Version Model")
        #endif
    }
}

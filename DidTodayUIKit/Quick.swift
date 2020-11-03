//
//  QuickButton.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/27.
//

import Foundation
import UIKit

class Quick {
    
    static let shared = Quick()
    let defaults = UserDefaults.standard
    
    struct Daily: Codable {
        
        private enum CodingKeys: String, CodingKey {
            case title, bgColour }
        
        var title: String
        var bgColour: UIColor
        
        init(title: String, bgColour: UIColor) {
            self.title = title
            self.bgColour = bgColour
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            title = try container.decode(String.self, forKey: .title)
            bgColour = try container.decode(Model.Color.self, forKey: .bgColour).uiColor
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(Model.Color(uiColor: bgColour), forKey: .bgColour)
        }
    }
    
    var dailys: [Daily] = [Daily(title: "Rest", bgColour: UIColor.systemPurple), Daily(title: "Meal", bgColour: UIColor.systemYellow), Daily(title: "Work", bgColour: UIColor.systemRed), Daily(title: "Study", bgColour: UIColor.systemGreen), Daily(title: "Add", bgColour: UIColor.systemBackground)]
    
    func addDaily(add: Daily) {
        dailys.insert(add, at: dailys.endIndex - 1)
    }
    
    func resetDaily(index: Int, daily: Daily) {
        dailys.remove(at: index)
        dailys.insert(daily, at: index)
    }
    func deleteDaily() {
        //TODO: 삭제 만들기
    }
    
    func setQuick() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(dailys) {
            defaults.set(encoded, forKey: "MyDaily")
        }
    }
    
    func loadQuick() {
        if let saved = defaults.object(forKey: "MyDaily") as? Data {
            let decoder = JSONDecoder()
            if let loadedQuick = try? decoder.decode([Daily].self, from: saved) {
                dailys = loadedQuick
            }
        }
    }
}


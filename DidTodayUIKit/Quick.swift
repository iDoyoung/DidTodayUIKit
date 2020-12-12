//
//  QuickButton.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/27.
//

import Foundation
import UIKit

class Quick {
//    
//    static let shared = Quick()
//    let defaults = UserDefaults.standard
//    
//    struct Daily: Codable {
//        
//        private enum CodingKeys: String, CodingKey {
//            case title, bgColour }
//        
//        var title: String
//        var bgColour: UIColor
//        
//        init(title: String, bgColour: UIColor) {
//            self.title = title
//            self.bgColour = bgColour
//        }
//        
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            
//            title = try container.decode(String.self, forKey: .title)
//            bgColour = try container.decode(Model.Color.self, forKey: .bgColour).uiColor
//        }
//        
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(title, forKey: .title)
//            try container.encode(Model.Color(uiColor: bgColour), forKey: .bgColour)
//        }
//    }
//   
//    var dailys: [Daily] = [Daily(title: "Rest".localized, bgColour: #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)), Daily(title: "Have a Meal".localized, bgColour: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)), Daily(title: "Work".localized, bgColour: #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)), Daily(title: "Study".localized, bgColour: #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)), Daily(title: "Eexrcise".localized, bgColour: #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1)), Daily(title: "Add".localized, bgColour: UIColor.clear)]
//    
//    func addDaily(add: Daily) {
//        dailys.insert(add, at: dailys.endIndex - 1)
//    }
//    
//    func resetDaily(index: Int, daily: Daily) {
//        dailys.remove(at: index)
//        dailys.insert(daily, at: index)
//    }
//    
//    func deleteDaily(index: Int) {
//        dailys.remove(at: index)
//    }
//    
//    func setQuick() {
//        let encoder = JSONEncoder()
//        
//        if let encoded = try? encoder.encode(dailys) {
//            defaults.set(encoded, forKey: "MyDaily")
//        }
//    }
//    
//    func loadQuick() {
//        if let saved = defaults.object(forKey: "MyDaily") as? Data {
//            let decoder = JSONDecoder()
//            if let loadedQuick = try? decoder.decode([Daily].self, from: saved) {
//                dailys = loadedQuick
//            }
//        }
//    }
}


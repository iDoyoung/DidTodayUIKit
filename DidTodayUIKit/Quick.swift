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
    
    struct Daily {
        var title: String
        var bgClour: UIColor
    }
    
    var dailys: [Daily] = [Daily(title: "Rest", bgClour: UIColor.systemPurple), Daily(title: "Meal", bgClour: UIColor.systemYellow), Daily(title: "Work", bgClour: UIColor.systemRed), Daily(title: "Study", bgClour: UIColor.systemGreen), Daily(title: "Add", bgClour: UIColor.systemBackground)]
}


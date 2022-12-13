//
//  UIColor+theme.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/24.
//

import UIKit

extension UIColor {
    class var themeGreen: UIColor {
        UIColor(red: 55/255, green: 162/255, blue: 112/255, alpha: 1)
    }
    
    class var customBackground: UIColor {
        UIColor(named: "custom.background") ?? .systemBackground
    }
    
    class var secondaryCustomBackground: UIColor {
        UIColor(named: "secondary.custom.background") ?? .systemBackground
    }
    
    class var customGreen: UIColor {
        UIColor(named: "custom.green") ?? .systemGreen
    }
}

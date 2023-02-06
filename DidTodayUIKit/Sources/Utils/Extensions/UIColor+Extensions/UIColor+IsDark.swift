//
//  UIColor+IsDark.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/02/06.
//

import UIKit

extension UIColor {
    func isDark() -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpah: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpah)
        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return luminance < 0.50
    }
}

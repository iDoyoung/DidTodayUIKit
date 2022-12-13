//
//  UIColor+GetRGB.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/13.
//

import UIKit

extension UIColor {
    func getRedOfRGB() -> CGFloat {
        guard let rgb = self.cgColor.components else { return 0 }
        return rgb[0]
    }
    
    func getGreenOfRGB() -> CGFloat {
        guard let rgb = self.cgColor.components else { return 0 }
        return rgb[1]
    }
    
    func getBlueRGB() -> CGFloat {
        guard let rgb = self.cgColor.components else { return 0 }
        return rgb[2]
    }
    
    func getAlpha() -> CGFloat {
        guard let rgb = self.cgColor.components else { return 1 }
        return rgb[3]
    }
}

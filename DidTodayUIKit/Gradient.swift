//
//  Gradient.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/11.
//

import Foundation
import UIKit

class Gradient: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    func midnight(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.1794443429, green: 0.150916189, blue: 0.4205605984, alpha: 1).cgColor ,#colorLiteral(red: 0.3882352941, green: 0.4823529412, blue: 0.7843137255, alpha: 1).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func evening(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.7019607843, green: 0.2117647059, blue: 0.8549019608, alpha: 1).cgColor ,#colorLiteral(red: 1, green: 0.5019607843, blue: 0.1411764706, alpha: 1).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func night(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.862745098, green: 0.6784313725, blue: 1, alpha: 1).cgColor ,#colorLiteral(red: 0.368627451, green: 0.01568627451, blue: 1, alpha: 1).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func afternoon(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.9921568627, green: 1, blue: 0.8196078431, alpha: 1).cgColor ,#colorLiteral(red: 0.1843137255, green: 0.7215686275, blue: 1, alpha: 1).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func dawn(view: UIView) {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.5607843137, green: 0.937254902, blue: 1, alpha: 1).cgColor ,#colorLiteral(red: 0.662745098, green: 0.5058823529, blue: 1, alpha: 1).cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

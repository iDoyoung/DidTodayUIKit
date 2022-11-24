//
//  UIView+Border.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/22.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
}

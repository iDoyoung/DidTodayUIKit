//
//  UIView+Corner Radius.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/11/14.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

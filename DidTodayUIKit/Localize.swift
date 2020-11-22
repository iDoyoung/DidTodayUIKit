//
//  Localize.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/18.
//

import Foundation

extension String {

     var localized: String {
           return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
        }
}




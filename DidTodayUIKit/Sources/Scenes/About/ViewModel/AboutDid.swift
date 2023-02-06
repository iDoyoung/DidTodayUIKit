//
//  AboutDid.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/23.
//

import UIKit

struct AboutDid {
    let image: UIImage?
    let title: String?
    let version: String?
    
    init(image: UIImage? = UIImage(named: "AppIcon"), title: String? = "Did", version: String? = getAppVersion()) {
        self.image = image
        self.title = title
        self.version = version
    }
    
    private static func getAppVersion() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return "???"
        }
        return "Version \(version)"
    }
}

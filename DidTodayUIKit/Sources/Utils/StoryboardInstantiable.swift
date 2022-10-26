//
//  StoryboardInstantiable.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/26.
//

import UIKit

protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype T
    static func instantiateViewController(storyboardName: String, _ bundle: Bundle?) -> T
}

extension StoryboardInstantiable {
    static func instantiateViewController(storyboardName: String, _ bundle: Bundle? = nil) -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError()
        }
        return viewController
    }
}

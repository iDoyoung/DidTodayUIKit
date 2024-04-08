//
//  SceneDelegate.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: MainFlowCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        assert(UserDefaults.standard.object(forKey: "Doing") == nil, "Do not have User Defaults data of key: \"Doing\"")
        window = UIWindow(windowScene: windowScene)
        
        let todayNavigationController = UINavigationController()
        window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
}


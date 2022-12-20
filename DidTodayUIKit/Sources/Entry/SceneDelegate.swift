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
        window = UIWindow(windowScene: windowScene)
        let initialViewController = UINavigationController()
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        coordinator = MainFlowCoordinator(navigationController: initialViewController, dependencies: SceneDIContainer())
        coordinator?.start()
    }
}


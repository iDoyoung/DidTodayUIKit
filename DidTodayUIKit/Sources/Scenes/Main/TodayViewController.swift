//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit
import SwiftUI
import Combine

final class TodayViewController: ParentUIViewController {
   
    //MARK: Componets
    var hostingController: UIHostingController<TodayRootView>!
   
    //MARK: - Life Cycle
    static func create(with updater: TodayViewUpdater) -> TodayViewController {
        let viewController = TodayViewController()
        viewController.hostingController = UIHostingController(rootView: TodayRootView(updater: updater))
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
  
    private func setupNavigationBar() {
        let dateOfToday = Date().toString()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = dateOfToday
    }
}

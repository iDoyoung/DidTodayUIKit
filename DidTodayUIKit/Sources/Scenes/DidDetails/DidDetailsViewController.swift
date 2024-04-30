//
//  DidDetailsViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/11.
//

import UIKit
import SwiftUI

final class DidDetailsViewController: ParentUIViewController {
    
    //MARK: - Properties
    var did: Did = Did(
        started: .init(),
        finished: .init(),
        content: "",
        color: .gray
    )
   
    lazy var rootView: DidDetailsRootView = {
        DidDetailsRootView(
            did: did
        )
    }()
    
    lazy var hostingController: UIHostingController<DidDetailsRootView>! = {
        UIHostingController(rootView: rootView)
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

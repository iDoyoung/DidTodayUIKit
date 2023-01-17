//
//  PrivacyPolicyViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/16.
//

import UIKit

final class PrivacyPolicyViewController: ParentUIViewController {

    var viewModel: PrivacyPolicyViewModelProtocol?
    //MARK: - Life Cycle
    static func create(with viewModel: PrivacyPolicyViewModelProtocol) -> PrivacyPolicyViewController {
        let viewController = PrivacyPolicyViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

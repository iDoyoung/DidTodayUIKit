//
//  DoingViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/02.
//

import UIKit

class DoingViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: DoingViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func create(with viewModel: DoingViewModelProtocol) -> DoingViewController {
        let viewControlelr = DoingViewController.instantiateViewController(storyboardName: "Doing")
        viewControlelr.viewModel = viewModel
        return viewControlelr
    }
}

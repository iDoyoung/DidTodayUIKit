//
//  DidDetailsViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/11.
//

import UIKit

final class DidDetailsViewController: UIViewController {

    private let didDetailView = DidDetailsView()
    var viewModel: DidDetailsViewModelProtocol?
    
    //MARK: - Life Cycle
    static func create(with viewModel: DidDetailsViewModelProtocol) -> DidDetailsViewController {
        let viewController = DidDetailsViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func loadView() {
        view = didDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

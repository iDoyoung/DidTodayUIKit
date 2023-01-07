//
//  DetailDayViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/04.
//

import UIKit

final class DetailDayViewController: DidListCollectionViewController {

    var viewModel: DetailDayViewModelProtocol?
    //MARK: - Life Cycle
    static func create(with viewModel: DetailDayViewModelProtocol) -> DetailDayViewController {
        let viewController = DetailDayViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        setupView()
        configureCollectionView()
        configureDataSource()
    }
    
    //MARK: - Setup
    private func setupView() {
        view.backgroundColor = .customBackground
    }
}


//
//  DetailDayViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/04.
//

import UIKit
import Combine

final class DetailDayViewController: DidListCollectionViewController {

    var viewModel: DetailDayViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    
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
        configureCollectionView()
        configureDataSource()
        bindViewModel()
    }
    
    override func configureCollectionView() {
        super.configureCollectionView()
        collectionView.backgroundColor = .customBackground
    }
    
    //MARK: - Binding
    private func bindViewModel() {
        viewModel?.totalPieDids
            .sink { [weak self] output in
                self?.applyTotalDidSnapshot([output])
            }
            .store(in: &cancellableBag)
        ///Bind Collection View with Did Item List
        viewModel?.didItemsList
            .sink { [weak self] output in
                self?.applyDidListSnapshot(output)
            }
            .store(in: &cancellableBag)
    }
    
    override func bindSortingSupplementaryWithViewModel(supplementary: SortingSupplementaryView) {
        super.bindSortingSupplementaryWithViewModel(supplementary: supplementary)
    }
}


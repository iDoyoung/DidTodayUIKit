//
//  DetailDayViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/04.
//

import UIKit
import Combine

final class DetailDayViewController: DidListCollectionViewController {

    
    //MARK: - Properties
    //MARK: Components
    var viewModel: DetailDayViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    
    //MARK: - Methods
    //MARK: Life cycle
    static func create(with viewModel: DetailDayViewModelProtocol) -> DetailDayViewController {
        let viewController = DetailDayViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchDids()
    }
    
    //MARK: Configure & Setup
    private func configure() {
        configureCollectionView()
        configureDataSource()
        bindViewModel()
        setTitle()
    }
    
    override func configureCollectionView() {
        super.configureCollectionView()
        collectionView.backgroundColor = .customBackground
        collectionView.delegate = self
    }
    
    private func setTitle() {
        viewModel?.selectedDay.sink { [weak self] output in
            self?.title = output
        }
        .store(in: &cancellableBag)
    }
    
    private func bindViewModel() {
        viewModel?.totalPieDids
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                self?.applyTotalDidSnapshot([output])
            }
            .store(in: &cancellableBag)
        ///Bind Collection View with Did Item List
        viewModel?.didItemsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                self?.applyDidListSnapshot(output)
            }
            .store(in: &cancellableBag)
    }
    
    override func bindSortingSupplementaryWithViewModel(supplementary: SortingSupplementaryView) {
        super.bindSortingSupplementaryWithViewModel(supplementary: supplementary)
        self.viewModel?.isSelectedRecentlyButton
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSelected, on: supplementary.recentlyButton)
            .store(in: &self.cancellableBag)
        
        self.viewModel?.isSelectedMuchTimeButton
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSelected, on: supplementary.muchTimeButton)
            .store(in: &self.cancellableBag)
    }
    
    //MARK: Actions
    @objc override func tapRecentlyButton(_ sender: UIButton) {
        super.tapRecentlyButton(sender)
        viewModel?.selectRecently()
    }
    
    @objc override func tapMuchTimeButton(_ sender: UIButton) {
        super.tapMuchTimeButton(sender)
        viewModel?.selectMuchTime()
    }
}

extension DetailDayViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == Section.list.rawValue {
            viewModel?.didSelectItem(at: indexPath.item)
        }
    }
}

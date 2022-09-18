//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit

final class MainViewController: UIViewController {
    ///Section for Did collection view in Main view controller
    private enum Section {
        case main
    }
    
    var viewModel: (MainViewModelInput & MainViewModelOutput)?
    
    private var didCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, MainDidItemsViewModel>!
    
    //MARK: - Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel = MainViewModel(didCoreDataStorage: DidCoreDataStorage())
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = MainViewModel(didCoreDataStorage: DidCoreDataStorage())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        viewModel?.fetchDids()
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        _ = viewModel.fetchedDidsPublisher.sink { [weak self] items in
            guard let items = items else { return }
            #if DEBUG
            print(items.count)
            #endif
            self?.applySnapShot(items)
        }
    }
    
}

//MARK: - CollectionView Extentions
extension MainViewController: UICollectionViewDelegate {
    /// - Tag: Configure
    private func configureCollectionView() {
        didCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        didCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        didCollectionView.backgroundColor = .secondarySystemBackground
        view.addSubview(didCollectionView)
    }
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(20)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    private func configureDataSource() {
        let cellRegistration = createCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, MainDidItemsViewModel>(collectionView: didCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    private func createCellRegistration() -> UICollectionView.CellRegistration<DidCell, MainDidItemsViewModel> {
        return UICollectionView.CellRegistration<DidCell, MainDidItemsViewModel> { cell, indexPath, item in
            cell.pieView.start = item.startedTimes
            cell.pieView.end = item.finishedTimes
            cell.contentLabel.text = item.content
        }
    }
    private func applySnapShot(_ items: [MainDidItemsViewModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MainDidItemsViewModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(items)
        dataSource.apply(snapShot)
    }
    /// - Tag: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

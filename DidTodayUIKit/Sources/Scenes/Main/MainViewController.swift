//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    //MARK: - UI Componets
    ///Section for Did collection view in Main view controller
    private enum Section: Int, CaseIterable {
        case total, list
    }
    
    var viewModel: (MainViewModelInput & MainViewModelOutput)?
    private var cancellableBag: AnyCancellable?
    private var didCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    //MARK: - Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel = MainViewModel(didCoreDataStorage: DidCoreDataStorage())
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = MainViewModel(didCoreDataStorage: DidCoreDataStorage.shared)
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
        cancellableBag = viewModel.fetchedDidsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let items = items else { return }
                #if DEBUG
                print(items.count)
                #endif
                self?.applyDidListSnapshot(items)
                self?.applyTotalDidSnapshot(items)
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
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .total:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            case .list:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(80))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 4, trailing: 12)
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
            }
            return section
        }
        return layout
    }
    private func configureDataSource() {
        let totalCellRegistration = createTotalDidsCellRegistration()
        let didListCellRegistration = createDidListCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: didCollectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .total:
                return collectionView.dequeueConfiguredReusableCell(using: totalCellRegistration,
                                                                    for: indexPath,
                                                                    item: item as? [MainDidItemsViewModel])
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: didListCellRegistration,
                                                                    for: indexPath,
                                                                    item: item as? MainDidItemsViewModel)
            }
        }
        initailSnapshot([])
    }
    //MARK: - Create Cell Registration
    private func createTotalDidsCellRegistration() -> UICollectionView.CellRegistration<TotalDidsCell, [MainDidItemsViewModel]> {
        return UICollectionView.CellRegistration<TotalDidsCell, [MainDidItemsViewModel]> { cell, IndexPath, item in
            cell.dids = item
        }
    }
    private func createDidListCellRegistration() -> UICollectionView.CellRegistration<DidCell, MainDidItemsViewModel> {
        return UICollectionView.CellRegistration<DidCell, MainDidItemsViewModel> { cell, indexPath, item in
            cell.pieView.start = item.startedTimes * 0.25
            cell.pieView.end = item.finishedTimes * 0.25
            cell.pieView.color = item.color
            cell.timeLabel.text = item.times
            cell.timeLabel.textColor = item.color
            cell.contentLabel.text = item.content
        }
    }
    //MARK: - Apply Snapshot
    private func initailSnapshot(_ items: [MainDidItemsViewModel]) {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)
        dataSource?.apply(snapshot)
        applyDidListSnapshot(items)
        applyTotalDidSnapshot(items)
    }
    private func applyTotalDidSnapshot(_ items: [MainDidItemsViewModel]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        snapshot.append([items])
        dataSource?.apply(snapshot, to: .total)
    }
    private func applyDidListSnapshot(_ items: [MainDidItemsViewModel]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        snapshot.append(items)
        dataSource?.apply(snapshot, to: .list)
    }
    
    /// - Tag: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

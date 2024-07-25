//
//  DidListCollectionViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/05.
//

import UIKit

class DidListCollectionViewController: ParentUIViewController {

    static let sectionHeaderElementKind = "section-header-element-kind"
    ///Section for Did collection view in Main view controller
    enum Section: Int, CaseIterable {
        case total, list
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    final func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .total:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                             leading: 10,
                                                             bottom: 0,
                                                             trailing: 10)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                return section
                
            case .list:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup
                    .horizontal(
                        layoutSize: groupSize,
                        repeatingSubitem: item,
                        count: 2
                    )
                
                group.interItemSpacing = .fixed(8)
                group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
                section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 10, trailing: 12)
                ///setup header
                let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                               heightDimension: .absolute(50))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                                elementKind: DidListCollectionViewController.sectionHeaderElementKind,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            }
        }
        return layout
    }
    
    final func configureDataSource() {
        let totalCellRegistration = createTotalDidsCellRegistration()
        let didListCellRegistration = createDidListCellRegistration()
        let sortingSupplementaryRegistration = createSortingSupplementaryRegistration(binding: bindSortingSupplementaryWithViewModel)

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .total:
                return collectionView.dequeueConfiguredReusableCell(using: totalCellRegistration,
                                                                    for: indexPath,
                                                                    item: item as? TotalOfDidsItemViewModel)
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: didListCellRegistration,
                                                                    for: indexPath,
                                                                    item: item as? DidItemViewModel)
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self] supplementaryView, elementKind, indexPath in
            return self?.collectionView.dequeueConfiguredReusableSupplementary(using: sortingSupplementaryRegistration,
                                                                                  for: indexPath)
        }
        initailSnapshot()
    }
    
    //MARK: - Create Registration
    final func createTotalDidsCellRegistration() -> UICollectionView.CellRegistration<TotalDidsCell, TotalOfDidsItemViewModel> {
        return UICollectionView.CellRegistration<TotalDidsCell, TotalOfDidsItemViewModel> { cell, IndexPath, item in
            cell.descriptionCountLabel.text = item.descriptionCount
            cell.descriptionTimeLabel.text = item.descriptionTime
            cell.setupPiesView(by: item)
        }
    }
    
    final func createDidListCellRegistration() -> UICollectionView.CellRegistration<DidCell, DidItemViewModel> {
        return UICollectionView.CellRegistration<DidCell, DidItemViewModel> { cell, indexPath, item in
            cell.pieView.start = item.startedTimes * 0.25
            cell.pieView.end = item.finishedTimes * 0.25
            cell.pieView.color = item.color
            cell.timeLabel.text = item.times
            cell.timeLabel.textColor = item.color
            cell.contentLabel.text = item.content
        }
    }
    
    final func createSortingSupplementaryRegistration(binding: @escaping (_: SortingSupplementaryView) -> Void) -> UICollectionView.SupplementaryRegistration<SortingSupplementaryView> {
        return UICollectionView.SupplementaryRegistration(elementKind: DidListCollectionViewController.sectionHeaderElementKind) { [weak self] supplementaryView, elementKind, _ in
            let recentlyButton = supplementaryView.recentlyButton
            let muchTimeButton = supplementaryView.muchTimeButton
            ///setup button action
            guard let self = self else { return }
            recentlyButton.addTarget(self, action: #selector(self.tapRecentlyButton), for: .touchUpInside)
            muchTimeButton.addTarget(self, action: #selector(self.tapMuchTimeButton), for: .touchUpInside)
            binding(supplementaryView)
        }
    }
    
    //MARK: - Apply Snapshot
    final func initailSnapshot() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)
        dataSource?.apply(snapshot)
        applyDidListSnapshot([])
        applyTotalDidSnapshot([])
    }
    
    final func applyTotalDidSnapshot(_ items: [TotalOfDidsItemViewModel]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        snapshot.append(items)
        dataSource?.apply(snapshot, to: .total)
    }
    
    final func applyDidListSnapshot(_ items: [DidItemViewModel]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        snapshot.append(items)
        dataSource?.apply(snapshot, to: .list)
    }
    
    //MARK: Set Sorting Supplementary View Buttons
    func bindSortingSupplementaryWithViewModel(supplementary: SortingSupplementaryView) {  }
    @objc func tapRecentlyButton(_ sender: UIButton) {  }
    @objc func tapMuchTimeButton(_ sender: UIButton) {  }
}



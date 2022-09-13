//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit

class ViewController: UIViewController {
    private enum Section {
        case main
    }
    private var didCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, DidItem>!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
}

//MARK: - CollectionView Extentions
extension ViewController: UICollectionViewDelegate {
    /// - Tag: Configure
    private func configureCollectionView() {
        didCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        didCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        didCollectionView.backgroundColor = .brown
        view.addSubview(didCollectionView)
    }
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    private func configureDataSource() {
        let cellRegistration = createCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, DidItem>(collectionView: didCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    private func createCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, DidItem> {
        return UICollectionView.CellRegistration<UICollectionViewCell, DidItem> { cell, indexPath, item in
            
        }
    }
    private func applySnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DidItem>()
        snapShot.appendSections([.main])
        snapShot.appendItems([])
        dataSource.apply(snapShot)
    }
    /// - Tag: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

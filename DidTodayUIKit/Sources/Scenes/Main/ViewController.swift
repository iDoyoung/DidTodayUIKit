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
        configureDataSource()
        applySnapShot()
    }
}

//MARK: - CollectionView Extentions
extension ViewController: UICollectionViewDelegate {
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
        dataSource = UICollectionViewDiffableDataSource<Section, DidItem>(collectionView: didCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    private func createCellRegistration() -> UICollectionView.CellRegistration<DidCell, DidItem> {
        return UICollectionView.CellRegistration<DidCell, DidItem> { cell, indexPath, item in
            cell.timeLabel.text = "00:00"
            cell.contentLabel.text = "테스트 중"
        }
    }
    private func applySnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DidItem>()
        snapShot.appendSections([.main])
        snapShot.appendItems([DidItem(id: UUID(),
                                      started: Date(),
                                      finished: Date(),
                                      content: "",
                                      red: 0,
                                      green: 0,
                                      blue: 0,
                                      alpha: 0)])
        dataSource.apply(snapShot)
    }
    /// - Tag: Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

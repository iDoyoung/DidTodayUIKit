//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit
import Combine

final class MainViewController: UIViewController, StoryboardInstantiable {
    
    ///Section for Did collection view in Main view controller
    private enum Section: Int, CaseIterable {
        case total, list
    }
    
    var viewModel: (MainViewModelInput & MainViewModelOutput)?
    private var cancellableBag: AnyCancellable?
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    //MARK: - UI Objects
    private var didCollectionView: UICollectionView!
    private lazy var quickButton: UIButton = {
        let button = UIButton()
        button.setTitle("Quick Move", for: .normal)
        button.menu = UIMenu()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var quickMenu: UIMenu = {
        return UIMenu(title: "", options: [], children: quickMenuItems)
    }()
    
    private lazy var quickMenuItems: [UIAction] = {
        return [UIAction(title: "Information",
                         image: UIImage(systemName: "info.circle")) { _ in },
                UIAction(title: "Calendar",
                         image: UIImage(systemName: "calendar")) { _ in },
                UIAction(title: "Create",
                         image: UIImage(systemName: "plus")) { _ in },
                UIAction(title: "Start",
                         image: UIImage(systemName: "flag.checkered")) { _ in }]
    }()
    
    //MARK: - Life Cycle
    static func create(with viewModel: MainViewModelProtocol) -> MainViewController {
        let viewController = MainViewController.instantiateViewController(storyboardName: StoryboardName.main)
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureCollectionView()
        configureDataSource()
        viewModel?.fetchDids()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        let todayDate = Date.todayDateToString()
        let buttonItem = UIBarButtonItem(title: todayDate, style: .plain, target: self, action: #selector(showCalendar))
        buttonItem.tintColor = .themeGreen
        navigationItem.leftBarButtonItem = buttonItem
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
    
    //MARK: Action Method
    @objc
    func showCalendar() {
        let destinationViewController = CalendarViewController()
        present(destinationViewController, animated: true)
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
                                                       heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: 2)
                group.interItemSpacing = .fixed(8)
                group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12)
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

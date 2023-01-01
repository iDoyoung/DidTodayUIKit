//
//  ViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/11.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    ///Section for Did collection view in Main view controller
    private enum Section: Int, CaseIterable {
        case total, list
    }
    
    var viewModel: (MainViewModelInput & MainViewModelOutput)?
    private var cancellableBag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>?
    
    //MARK: - UI Objects
    private var didCollectionView: UICollectionView!
    
    private lazy var startButton: NeumorphismButton = {
        let button = NeumorphismButton(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        return button
    }()
    
    private let informationLabel: BoardLabel = {
        let label = BoardLabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemGray
        label.texts = ["아래 버튼을 누르면 시간을 재기 시작해요", "터치하여 무슨 일이던 시작해보세요"]
        return label
    }()
    
    private lazy var quickButton: UIButton = {
        let button = UIButton()
        button.setTitle("Quick Move", for: .normal)
        button.setTitleColor(.customGreen, for: .normal)
        button.menu = quickMenu
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var quickMenu: UIMenu = {
        return UIMenu(title: "", options: [], children: quickMenuItems)
    }()
    
    private lazy var quickMenuItems: [UIAction] = {
        return [
            UIAction(title: "Start",
                     image: UIImage(systemName: "flag.checkered")) { [weak self] _ in
                         guard let self = self else { return }
                         self.viewModel?.showDoing()
                     },
            UIAction(title: "Create Did",
                     image: UIImage(systemName: "plus")) { [weak self] _ in
                         guard let self = self else { return }
                         self.viewModel?.showCreateDid()
                     },
            UIAction(title: "Calendar",
                     image: UIImage(systemName: "calendar")) { [weak self] _ in
                         guard let self = self else { return }
                         self.viewModel?.showCalendar()
                     },
            UIAction(title: "Information",
                     image: UIImage(systemName: "info.circle")) { [weak self] _ in
                         guard let self = self else { return }
                         self.viewModel?.showAbout()
                     }]
    }()
    
    //MARK: - Life Cycle
    static func create(with viewModel: MainViewModelProtocol) -> MainViewController {
        let viewController = MainViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    ///Primary setup
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchDids()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        informationLabel.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        informationLabel.stopAnimation()
    }
    
    
    private func configure() {
        setupNavigationBar()
        ///Layout Herarchy: Collection View 부터 구성후 버튼을 추가해야한다.
        ///Collection View
        configureCollectionView()
        configureDataSource()
        
        view.addSubview(quickButton)
        view.addSubview(startButton)
        view.addSubview(informationLabel)
        setupConstraintLayout()
        ///Bind
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .bold)
        let logoImage = UIImage(named: "app.logo")
        let plusImage = UIImage(systemName: "plus", withConfiguration: imageConfiguration)
        let calendarImage = UIImage(systemName: "calendar", withConfiguration: imageConfiguration)
        
        ///Setup Left Item
        let logoItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(showAbout))
        navigationItem.leftBarButtonItem = logoItem
        
        ///Setup Right Items
        let addItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(showCreateDid))
        let calendarItem = UIBarButtonItem(image: calendarImage, style: .plain, target: self, action: #selector(showCalendar))
        navigationItem.rightBarButtonItems = [addItem, calendarItem]
        
        navigationController?.navigationBar.tintColor = .customGreen
    }
    
    //MARK: - Binding
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        viewModel.totalPieDids
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applyTotalDidSnapshot([items])
            }
            .store(in: &cancellableBag)
        viewModel.didItemsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.applyDidListSnapshot(items)
            }
            .store(in: &cancellableBag)
    }
    
    //MARK: - Setup
    private func setupConstraintLayout() {
        quickButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            quickButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            quickButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            startButton.heightAnchor.constraint(equalToConstant: startButton.frame.height),
            startButton.widthAnchor.constraint(equalToConstant: startButton.frame.width),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: quickButton.topAnchor),
            informationLabel.widthAnchor.constraint(equalToConstant: 300),
            informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            informationLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -10)
        ])
    }
    
    //MARK: - Action Method
    @objc func showAbout() {
        viewModel?.showAbout()
    }
    
    @objc func showCalendar() {
        viewModel?.showCalendar()
    }
    
    @objc func showCreateDid() {
        viewModel?.showCreateDid()
    }
}

//MARK: - CollectionView Extentions
extension MainViewController {
    /// - Tag: Configure
    private func configureCollectionView() {
        didCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        didCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        didCollectionView.backgroundColor = .customBackground
        didCollectionView.delegate = self
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 10, trailing: 12)
                ///setup header
                let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                               heightDimension: .absolute(50))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                                elementKind: MainViewController.sectionHeaderElementKind,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        }
        return layout
    }
    
    private func configureDataSource() {
        let totalCellRegistration = createTotalDidsCellRegistration()
        let didListCellRegistration = createDidListCellRegistration()
        let sortingSupplementaryRegistration = createSortingSupplementaryRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: didCollectionView) { collectionView, indexPath, item in
            guard let section = Section(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch section {
            case .total:
                return collectionView.dequeueConfiguredReusableCell(using: totalCellRegistration,
                                                                    for: indexPath,
                                                                    item: item as? MainTotalOfDidsItemViewModel)
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: didListCellRegistration,
                                                                    for: indexPath,
                                                                    item: item as? MainDidItemsViewModel)
            }
        }
        dataSource?.supplementaryViewProvider = { [weak self] supplementaryView, elementKind, indexPath in
            return self?.didCollectionView.dequeueConfiguredReusableSupplementary(using: sortingSupplementaryRegistration,
                                                                                  for: indexPath)
        }
        initailSnapshot()
    }
    
    //MARK: - Create Registration
    private func createTotalDidsCellRegistration() -> UICollectionView.CellRegistration<TotalDidsCell, MainTotalOfDidsItemViewModel> {
        return UICollectionView.CellRegistration<TotalDidsCell, MainTotalOfDidsItemViewModel> { cell, IndexPath, item in
            cell.descriptionCountLabel.text = item.descriptionCount
            cell.descriptionTimeLabel.text = item.descriptionTime
            cell.setupPiesView(by: item)
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
    
    private func createSortingSupplementaryRegistration() -> UICollectionView.SupplementaryRegistration<SortingSupplementaryView> {
        return UICollectionView.SupplementaryRegistration(elementKind: MainViewController.sectionHeaderElementKind) { [weak self] supplementaryView, elementKind, _ in
            ///setup button action
            guard let self = self else { return }
            supplementaryView.recentlyButton.addTarget(self, action: #selector(self.tapRecentlyButton), for: .touchUpInside)
            supplementaryView.muchTimeButton.addTarget(self, action: #selector(self.tapMuchTimeButton), for: .touchUpInside)
            
            //TODO: Binding
            ///Binding
            self.viewModel?.isSelectedRecentlyButton
                .receive(on: DispatchQueue.main)
                .sink { supplementaryView.recentlyButton.isSelected  = $0 }
                .store(in: &self.cancellableBag)
            ///Binding Much Time Button
            self.viewModel?.isSelectedMuchTimeButton
                .receive(on: DispatchQueue.main)
                .sink { supplementaryView.muchTimeButton.isSelected = $0 }
                .store(in: &self.cancellableBag)
        }
    }
    
    //MARK: - Apply Snapshot
    private func initailSnapshot() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(sections)
        dataSource?.apply(snapshot)
        applyDidListSnapshot([])
        applyTotalDidSnapshot([])
    }
    
    private func applyTotalDidSnapshot(_ items: [MainTotalOfDidsItemViewModel]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        snapshot.append(items)
        dataSource?.apply(snapshot, to: .total)
    }
    
    private func applyDidListSnapshot(_ items: [MainDidItemsViewModel]) {
        var snapshot = NSDiffableDataSourceSectionSnapshot<AnyHashable>()
        snapshot.append(items)
        dataSource?.apply(snapshot, to: .list)
    }
    
    //MARK: Button Action in Supplementary View
    @objc func tapRecentlyButton() {
        viewModel?.selectRecently()
    }
    
    @objc func tapMuchTimeButton() {
        viewModel?.selectMuchTime()
    }
}

extension MainViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        informationLabel.alpha = 0
        startButton.isHidden = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            informationLabel.alpha = 1
            startButton.isHidden = false
        }
    }
}

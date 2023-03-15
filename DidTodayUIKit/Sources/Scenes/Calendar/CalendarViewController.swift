//
//  CalendarViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/22.
//

import UIKit
import Combine
import HorizonCalendar

final class CalendarViewController: ParentUIViewController {
    
    ///Section of lise of dids collection view
    private enum Section: Int, CaseIterable {
        case didsOfSelected
    }
    //MARK: - Properties
    
    //MARK: Static
    static let sectionHeaderElementKind = "layout-header-element-kind"
    
    //MARK: Components
    var viewModel: CalendarViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DidsOfDayItemViewModel>?
    
    //MARK: UI Properties
    private lazy var calendarView: CalendarView = CalendarView(initialContent: setupCalendarViewContents())
    private var collectionView: UICollectionView!
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [calendarView, collectionView, bottomView])
        stackView.axis = .vertical
        stackView.backgroundColor = .separator
        stackView.layer.borderColor = UIColor.separator.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.cornerRadius = 20
        stackView.layer.masksToBounds = true
        stackView.spacing = 0.5
        return stackView
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        view.backgroundColor = .systemBackground
        view.addSubview(showDetailButton)
        return view
    }()
    
    private lazy var showDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CustomText.showDetail, for: .normal)
        button.tintColor = .label
        button.isSelected = true
        button.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Methods
    //MARK: Life Cycle
    static func create(with viewModel: CalendarViewModelProtocol) -> CalendarViewController {
        let viewController = CalendarViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    //FIXME: - calendarView.scroll issue
    ///loadView() 로 prent view 생성할 경우, viewDidLoad() 에서 calendarView.scroll 할 경우,
    ///"Will attempt to recover by breaking constrain" Issue
//    override func loadView() {
//        view = UIView()
//        view.backgroundColor = .systemBackground
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// - Tag: Configure Calendar After Fetch Dids
        bindViewModel()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.fetchDids()
    }
    
    //MARK: Configure & Setup
    private func configure() {
        setupView()
        setupNavigationBar()
        configureCollectionView()
        configureStackView()
        setupLayoutConstraints()
        configureCalendarView()
    }
    
    private func setupView() {
        view.borderColor = .clear
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        view.addSubview(blurredEffectView)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .default)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: imageConfiguration)
        let rightBarButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func configureStackView() {
        view.addSubview(verticalStackView)
    }
        
    private func setupLayoutConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        showDetailButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            showDetailButton.leadingAnchor.constraint(greaterThanOrEqualTo: bottomView.leadingAnchor),
            showDetailButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
            showDetailButton.topAnchor.constraint(greaterThanOrEqualTo: bottomView.topAnchor),
            showDetailButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -20)
        ])
    }
    
    //MARK: Binding
    ///Binding with View Model
    func bindViewModel() {
        viewModel?.displayedItemsOfDidSelectedDay
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                self.showDetailButton.isEnabled = !items.isEmpty
                self.initialSnapshot(items)
            }
            .store(in: &cancellableBag)
    }
}

//MARK: Actions
extension CalendarViewController {
    
    @objc private func close() {
        dismiss(animated: true)
    }

    @objc private func showDetail() {
        viewModel?.showDetail()
    }
}

//MARK: - Configure Calendar View
extension CalendarViewController {
    
    private func configureCalendarView() {
        calendarView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        calendarView.backgroundColor = .systemBackground
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            self.viewModel?.selectedDay = day.components
            let newContent = self.setupCalendarViewContents()
            self.calendarView.setContent(newContent)
        }
        scrollToToday()
    }
    
    //TODO: Refactor
    private func setupCalendarViewContents() -> CalendarViewContent {
        let calendar = Calendar.current
        //FIXME: - To date of first uploaded date
        let startDate = viewModel?.startedDate ?? Date()
        let endDate = Date()
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical (
                options: VerticalMonthsLayoutOptions(
                    pinDaysOfWeekToTop: true,
                    alwaysShowCompleteBoundaryMonths: true,
                    scrollsToFirstMonthOnStatusBarTap: true)))
        .monthHeaderItemProvider { month in
            CalendarItemModel<MonthLabel> (
                invariantViewProperties: .init(
                    font: .systemFont(ofSize: 17, weight: .medium),
                    textColor: .label,
                    backgroundColor: .clear),
                viewModel: .init(month: month))
        }
        .dayItemProvider { [weak self] day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(font: .systemFont(ofSize: 14, weight: .semibold),
                                                                           textColor: .darkGray,
                                                                           backgroundColor: .clear)
            ///Setup Seleted day
            if let self = self,
               let viewModel = self.viewModel {
                if day.components == viewModel.selectedDay {
                    invariantViewProperties.textColor = .systemBackground
                    invariantViewProperties.backgroundColor = .label
                }
                ///Setup today
                if day.components == calendar.dateComponents([.era, .year, .month, .day], from: Date()) {
                    invariantViewProperties.textColor = .systemBackground
                    invariantViewProperties.backgroundColor = .systemRed
                }
                //TODO: Binding
                viewModel.dateOfDids
                    .sink { dateOfDids in
                        for date in dateOfDids {
                            if day.components == calendar.dateComponents([.era, .year, .month, .day], from: date) {
                                invariantViewProperties.textColor = .customGreen
                                break
                            }
                        }
                    }
                    .store(in: &self.cancellableBag)
            }
            return CalendarItemModel<DayLabel> (
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(day: day))
        }
        .monthDayInsets(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        .interMonthSpacing(60)
        .horizontalDayMargin(8)
        .verticalDayMargin(8)
    }
    
    private func scrollToToday() {
        calendarView.scroll(toMonthContaining: Date(), scrollPosition: .lastFullyVisiblePosition, animated: false)
    }
}

//MARK: - Collection View
extension CalendarViewController {
     
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.isScrollEnabled = false
        configureDataSource()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(32),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(32),
                                               heightDimension: .absolute(34))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing =  10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 10,
                                                        bottom: 0,
                                                        trailing: 10)
        ///setup header
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: CalendarViewController.sectionHeaderElementKind,
                                                                        alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        let didTitleCellRegistration = createDidTitleCellRegistration()
        let didsOfSelectedSupplementaryRegistration = createDidsOfSelectedSupplementaryRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, DidsOfDayItemViewModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(
                    using: didTitleCellRegistration,
                    for: indexPath,
                    item: itemIdentifier)
            })
        dataSource?.supplementaryViewProvider = { [weak self] supplementaryView, elementKind, indexPath in
            self?.collectionView.dequeueConfiguredReusableSupplementary(using: didsOfSelectedSupplementaryRegistration, for: indexPath)
        }
    }
    
    //MARK: Create Registration
    private func createDidsOfSelectedSupplementaryRegistration() -> UICollectionView.SupplementaryRegistration<DetailDidSupplementaryView> {
        UICollectionView.SupplementaryRegistration(elementKind: CalendarViewController.sectionHeaderElementKind) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self,
                  let viewModel = self.viewModel else { return }
            ///Binding with ViewModel
            viewModel.descriptionOfSelectedDay
                .sink {
                    supplementaryView.descriptionCountLabel.text = $0
                }
                .store(in: &self.cancellableBag)
        }
    }
    
    private func createDidTitleCellRegistration() -> UICollectionView.CellRegistration<DidTitleCell, DidsOfDayItemViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.borderWidth = 2
            cell.borderColor = .separator
            cell.titleLabel.text = itemIdentifier.title
            cell.titleLabel.textColor = itemIdentifier.color.isDark() ? .white : .black
            cell.backgroundColor = itemIdentifier.color
        }
    }
   
    private func initialSnapshot(_ items: [DidsOfDayItemViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DidsOfDayItemViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

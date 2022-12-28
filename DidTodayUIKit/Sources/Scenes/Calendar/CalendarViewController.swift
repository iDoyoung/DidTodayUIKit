//
//  CalendarViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/22.
//

import UIKit
import Combine
import HorizonCalendar

final class CalendarViewController: UIViewController {
    
    static let sectionHeaderElementKind = "layout-header-element-kind"
    
    private enum Section: Int, CaseIterable {
        case didsOfSelected
    }
    
    var viewModel: CalendarViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DidsOfDayItemViewModel>?
    
    //MARK: - UI Objects
    private lazy var calendarView: CalendarView = CalendarView(initialContent: setupCalendarViewContents())
    private var collectionView: UICollectionView!
    private lazy var verticalStactView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [collectionView, calendarView])
        stackView.axis = .vertical
        stackView.backgroundColor = .systemBackground
        stackView.layer.borderColor = UIColor.separator.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.cornerRadius = 20
        stackView.shadowOpacity = 0.3
        stackView.shadowRadius = 10
        stackView.spacing = 1.5
        return stackView
    }()
    
    //MARK: - Life Cycle
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
        configure()
    }
    
    //MARK: - Configure UI
    private func configure() {
        view.backgroundColor = .customBackground
        setupNavigationBar()
        configureCalendarView()
        configureCollectionView()
        configureStackView()
        setupLayoutConstraints()
        calendarView.scroll(toDayContaining: Date(), scrollPosition: .firstFullyVisiblePosition, animated: false)
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .default)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: imageConfiguration)
        let rightBarButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func configureStackView() {
        view.addSubview(verticalStactView)
    }
        
    private func setupLayoutConstraints() {
        verticalStactView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStactView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            verticalStactView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            verticalStactView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            verticalStactView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)])
    }
}

extension CalendarViewController {
    
    @objc private func close() {
        dismiss(animated: true)
    }
}

//MARK: - Configure Calendar View
extension CalendarViewController {
    
    private func configureCalendarView() {
        calendarView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        calendarView.backgroundColor = .clear
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            self.viewModel?.selectedDay = day.components
            let newContent = self.setupCalendarViewContents()
            self.calendarView.setContent(newContent)
        }
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
            if let self = self, let viewModel = self.viewModel {
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
}

//MARK: - Configure Collection View
extension CalendarViewController {
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        configureDataSource()
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(10),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(0),
                                               heightDimension: .absolute(38))
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
        viewModel?.didsOfDayItem
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in
                guard let self = self else { return }
                self.initialSnapshot(items)
            })
            .store(in: &cancellableBag)
    }
    
    //MARK: - Create Registration
    private func createDidsOfSelectedSupplementaryRegistration() -> UICollectionView.SupplementaryRegistration<DetailDidSupplementaryView> {
        UICollectionView.SupplementaryRegistration(elementKind: CalendarViewController.sectionHeaderElementKind) { [weak self] supplementaryView, elementKind, indexPath in
            guard let self = self,
                  let viewModel = self.viewModel else { return }
            viewModel.descriptionOfSelectedDay
                .sink { supplementaryView.descriptionCountLabel.text = $0 }
                .store(in: &self.cancellableBag)
        }
    }
    
    private func createDidTitleCellRegistration() -> UICollectionView.CellRegistration<DidTitleCell, DidsOfDayItemViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.sizeToFit()
            cell.titleLabel.text = itemIdentifier.title
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

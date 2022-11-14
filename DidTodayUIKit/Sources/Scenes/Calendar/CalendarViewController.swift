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
    
    private enum Section: CaseIterable {
        case title
    }
    var viewModel: CalendarViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, DidsOfDayItemViewModel>?
    private var sizeOfDidTitleCell: [CGSize] = []
    //MARK: - UI Objects
    private lazy var calendarView: CalendarView = CalendarView(initialContent: setupCalendarViewContents())
    private var didsOfDayCollectionView: UICollectionView!
    private lazy var verticalStactView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [calendarView, didsOfDayCollectionView])
        stackView.axis = .vertical
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 20
        stackView.backgroundColor = .clear
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.separator.cgColor
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
        configureUI()
    }
    
    //MARK: - Configure UI
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        configureCalendarView()
        configureDidsCollectionView()
        configureStackView()
        setupLayoutConstraints()
        calendarView.scroll(toDayContaining: Date(), scrollPosition: .firstFullyVisiblePosition, animated: false)
    }
    
    private func configureStackView() {
        view.addSubview(verticalStactView)
    }
        
    private func setupLayoutConstraints() {
        verticalStactView.translatesAutoresizingMaskIntoConstraints = false
        didsOfDayCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            didsOfDayCollectionView.heightAnchor.constraint(equalToConstant: 50),
            verticalStactView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            verticalStactView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            verticalStactView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            verticalStactView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)])
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
            if day.components == self?.viewModel?.selectedDay {
                invariantViewProperties.textColor = .systemBackground
                invariantViewProperties.backgroundColor = .label
            }
            ///Setup today
            if day.components == calendar.dateComponents([.era, .year, .month, .day], from: Date()) {
                invariantViewProperties.textColor = .systemBackground
                invariantViewProperties.backgroundColor = .systemRed
            }
            //TODO: Binding
            if let viewModel = self?.viewModel {
                viewModel.dateOfDidsPublisher.sink { dateOfDids in
                    for date in dateOfDids {
                        if day.components == calendar.dateComponents([.era, .year, .month, .day], from: date) {
                            invariantViewProperties.textColor = .green
                            break
                        }
                    }
                }
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
    
    private func configureDidsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        didsOfDayCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        configureDataSource()
        didsOfDayCollectionView.delegate = self
    }
    
    private func configureDataSource() {
        let didTitleCellRegistration = createDidTitleCellRegistration()
        dataSource = UICollectionViewDiffableDataSource<Section, DidsOfDayItemViewModel>(
            collectionView: didsOfDayCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(
                    using: didTitleCellRegistration,
                    for: indexPath,
                    item: itemIdentifier)
            })
        viewModel?.didsOfDayItemSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in
                guard let self = self else { return }
                self.sizeOfDidTitleCell = items.map {
                    let stringSize = $0.title.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                    return CGSize(
                        width: stringSize.width + 25,
                        height: 30)
                }
                self.initailSnapshot(items)
            })
            .store(in: &cancellableBag)
    }
    
    private func createDidTitleCellRegistration() -> UICollectionView.CellRegistration<DidTitleCell, DidsOfDayItemViewModel> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier.title
            cell.titleLabel.backgroundColor = itemIdentifier.color
        }
    }
   
    private func initailSnapshot(_ items: [DidsOfDayItemViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DidsOfDayItemViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeOfDidTitleCell[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin: CGFloat = 20
        return UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
    }
}

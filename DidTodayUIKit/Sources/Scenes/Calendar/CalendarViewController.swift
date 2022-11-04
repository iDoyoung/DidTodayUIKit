//
//  CalendarViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/22.
//

import UIKit
import Combine
import HorizonCalendar

class CalendarViewController: UIViewController {
    
    var viewModel: CalendarViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Int, AnyHashable>?
    private var selectedDay: Day?
    
    //MARK: - UI Objects
    private lazy var calendarView: CalendarView = {
        let calendarView = CalendarView(initialContent: configureCalendarViewContents())
        calendarView.directionalLayoutMargins = NSDirectionalEdgeInsets()
        calendarView.scroll(toDayContaining: Date(), scrollPosition: .centered, animated: false)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    private var didsCollectionView: UICollectionView!
    
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
    
    //MARK: - Configure
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(calendarView)
        configureDidsCollectionView()
        setupLayoutConstraints()
    }
    
    private func configureCalendarViewContents() -> CalendarViewContent {
        let selectedDay = self.selectedDay
        let calendar = Calendar.current
        //FIXME: - To date of first uploaded date
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
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
                    font: .systemFont(ofSize: 20, weight: .medium),
                    textColor: .label,
                    backgroundColor: .clear),
                viewModel: .init(month: month))
        }
        .dayItemProvider { [weak self] day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(font: .systemFont(ofSize: 16, weight: .semibold),
                                                                           textColor: .darkGray,
                                                                           backgroundColor: .clear)
            if day == selectedDay {
                invariantViewProperties.textColor = .systemBackground
                invariantViewProperties.backgroundColor = .label
            }
            ///Setup today
            if day.components == Calendar.current.dateComponents([.era, .year, .month, .day], from: Date()) {
                invariantViewProperties.textColor = .systemBackground
                invariantViewProperties.backgroundColor = .systemRed
            }
            //TODO: Binding
            if let viewModel = self?.viewModel {
                viewModel.dateOfDidsPublisher.sink { dateOfDids in
                    for date in dateOfDids {
                        if day.components == Calendar.current.dateComponents([.era, .year, .month, .day], from: date) {
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
        .interMonthSpacing(60)
        .horizontalDayMargin(8)
    }
    
    private func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
            didsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            didsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            didsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: didsCollectionView.topAnchor),
        ])
    }
}

//MARK: - Configure Collection View
extension CalendarViewController {
    
    private func configureDidsCollectionView() {
        didsCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout())
        didsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(didsCollectionView)
        configureDataSource()
        didsCollectionView.delegate = self
    }
    
    private func configureDataSource() {
        let didTitleCellRegistration = createDidTitleCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: didsCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(
                    using: didTitleCellRegistration,
                    for: indexPath,
                    item: itemIdentifier as? String)
        })
    }
    
    private func createDidTitleCellRegistration() -> UICollectionView.CellRegistration<DidTitleCell, String> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            cell.titleLabel.text = itemIdentifier
        }
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 227, height: 400)
    }
}

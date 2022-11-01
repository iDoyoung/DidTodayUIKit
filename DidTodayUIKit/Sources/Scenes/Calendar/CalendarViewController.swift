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
    private lazy var calendarView: CalendarView = {
        let calendarView = CalendarView(initialContent: configureCalendarViewContents())
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    //TODO: Need to do bind with view model?
    ///Selected Day of Calendar View
    private var selectedDay: Day?
    
    //MARK: - Life Cycle
    static func create(with viewModel: CalendarViewModelProtocol) -> CalendarViewController {
        let viewController = CalendarViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIComponents()
    }
    
    //MARK: - Configure
    private func configureUIComponents() {
        view.addSubview(calendarView)
        setupLayoutConstraints()
    }
    
    private func configureCalendarViewContents() -> CalendarViewContent {
        let selectedDay = self.selectedDay
        let calendar = Calendar.current
        //FIXME: - To date of first uploaded date
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
        let endDate = Date().omittedTime()
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(
                options: VerticalMonthsLayoutOptions(
                    pinDaysOfWeekToTop: false,
                    alwaysShowCompleteBoundaryMonths: false,
                    scrollsToFirstMonthOnStatusBarTap: false)))
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
    
    func setupLayoutConstraints() {
        NSLayoutConstraint.activate([
          calendarView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
          calendarView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
          calendarView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
          calendarView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
}

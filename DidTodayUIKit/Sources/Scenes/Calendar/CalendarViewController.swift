//
//  CalendarViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/10/22.
//

import UIKit
import HorizonCalendar

class CalendarViewController: UIViewController {
    
    var viewModel: CalendarViewModelProtocol?
    private lazy var calendarView: CalendarView = {
        let calendarView = CalendarView(initialContent: configureCalendarViewContents())
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    ///Selected Day of Calendar View
    private var selectedDay: Day?
    
    //MARK: - Life Cycle
    static func create(with viewModel: CalendarViewModelProtocol) -> CalendarViewController {
        let viewController = CalendarViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Configure
    private func configureUIComponents() {
        view.addSubview(calendarView)
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
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
        .monthHeaderItemProvider { month in
            CalendarItemModel<MonthLabel> (
                invariantViewProperties: .init(
                    font: .systemFont(ofSize: 20, weight: .medium),
                    textColor: .label,
                    backgroundColor: .clear),
                viewModel: .init(month: month))
        }
        .dayItemProvider { day in
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
            return CalendarItemModel<DayLabel> (
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(day: day))
        }
        .interMonthSpacing(60)
        .horizontalDayMargin(8)
    }
}

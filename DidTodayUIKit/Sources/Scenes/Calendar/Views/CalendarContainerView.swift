//
//  CalendarContainerView.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/04/04.
//

import UIKit
import PinLayout
import FlexLayout
import HorizonCalendar

final class CalendarContainerView: UIView {
    
    //MARK: UI Properties
    
    private let rootFlexContainer = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = CustomText.whichDayDidYou
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: .bold)
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
        // 생각과 다르게 반응한다.
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var calendarView: CalendarView!
   
    init() {
        super.init(frame: .zero)
        calendarView = CalendarView(initialContent: setupCalendarViewContents())
        //FIXME: - Calendar View에 Frame 적용하지 않을 경우 Breaking constraint waring 발생, width&height가 0일 경우에도 발생
        calendarView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .backgroundColor(.systemBackground)
            .direction(.column)
            .alignItems(.end)
            .define { flex in

                flex.addItem(titleLabel)
                    .paddingVertical(20)
                    .start(20)
                    .width(100%)
                
                flex.addItem(imageView)
                    .backgroundColor(.systemRed)
                    .grow(1)
                    .width(100%)
                
                flex.addItem(calendarView)
                    .width(100%)
                    .grow(1)
                    .define { flex in
                        guard let calendar = flex.view as? CalendarView else { return }
                        calendar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                    }
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin
            .all(pin.safeArea)
        
        rootFlexContainer.flex.layout()
    }
}

//MARK: - Calender
extension CalendarContainerView {
    func setupCalendarViewContents(selected: Date? = nil, fetched: [Date] = []) -> CalendarViewContent {
        let calendar = Calendar.current
        //Start Date를 기본적으로 설정하지 않으면 UI가 부자연스러움
        let startDate = calendar.date(from: DateComponents(year: 2019, month: 01, day: 01))!
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...Date(),
            monthsLayout: .vertical (
                options: VerticalMonthsLayoutOptions(
                    pinDaysOfWeekToTop: true,
                    alwaysShowCompleteBoundaryMonths: true,
                    scrollsToFirstMonthOnStatusBarTap: true)))
        
        // Month Hearder
        .monthHeaderItemProvider { month in
            CalendarItemModel<MonthLabel> (
                invariantViewProperties: .init(
                    font: .systemFont(ofSize: 17, weight: .medium),
                    textColor: .label,
                    backgroundColor: .clear),
                content: .init(month: month))
        }
        
        // Day Item
        .dayItemProvider { day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(font: .systemFont(ofSize: 14, weight: .semibold),
                                                                           textColor: .darkGray,
                                                                           backgroundColor: .clear)
            // Setup Today UI
            if day.components == calendar.dateComponents([.era, .year, .month, .day], from: Date()) {
                invariantViewProperties.textColor = .systemBackground
                invariantViewProperties.backgroundColor = .systemRed
            }
            
            // Setup Selected Day UI
            if calendar.date(from: day.components) == selected {
                invariantViewProperties.textColor = .systemBackground
                invariantViewProperties.backgroundColor = .label
            }
            
            // Setup Fetched Day UI
            fetched.forEach {
                if calendar.date(from: day.components) == $0 {
                    invariantViewProperties.textColor = .customGreen
                }
            }
            
            return CalendarItemModel<DayLabel> (
                invariantViewProperties: invariantViewProperties,
                content: .init(day: day))
        }
        .monthDayInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
        .interMonthSpacing(60)
        .horizontalDayMargin(8)
        .verticalDayMargin(8)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct CalendarPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = CalendarContainerView()
            return view
        }
    }
}
#endif

//
//  MonthLabel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/25.
//

import UIKit
import HorizonCalendar

struct MonthLabel: CalendarItemViewRepresentable {
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        let textColor: UIColor
        let backgroundColor: UIColor
    }
    /// Properties that will vary depending on the particular date being displayed.
    struct ViewModel: Equatable {
        let month: Month
    }
    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> UILabel {
        let label = UILabel()
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        return label
    }
    static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
        let calendar = Calendar.current
        let monthHeaderDateFormatter = DateFormatter()
        monthHeaderDateFormatter.calendar = calendar
        monthHeaderDateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMMM yyyy",
            options: 0,
            locale: calendar.locale ?? Locale.current)
        guard let monthDate = calendar.date(from: viewModel.month.components) else {
            preconditionFailure()
        }
        view.text = monthHeaderDateFormatter.string(from: monthDate)
    }
}

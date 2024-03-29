//
//  DayLabel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/25.
//

import UIKit
import HorizonCalendar

struct DayLabel: CalendarItemViewRepresentable {
    /// Properties that are set once when we initialize the view.
    struct InvariantViewProperties: Hashable {
        let font: UIFont
        var textColor: UIColor
        var backgroundColor: UIColor
    }
    /// Properties that will vary depending on the particular date being displayed.
    struct Content: Equatable {
        let day: Day
    }
    
    static func makeView(withInvariantViewProperties invariantViewProperties: InvariantViewProperties) -> UILabel {
        let label = UILabel()
        label.backgroundColor = invariantViewProperties.backgroundColor
        label.font = invariantViewProperties.font
        label.textColor = invariantViewProperties.textColor
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        return label
    }
    
    static func setContent(_ content: Content, on view: UILabel) {
        view.text = "\(content.day.day)"
    }
}

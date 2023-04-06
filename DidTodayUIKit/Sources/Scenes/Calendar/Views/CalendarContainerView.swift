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
    
    static let sectionHeaderElementKind = "layout-header-element-kind"
    
    //MARK: UI Properties
    let effectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemMaterial)
        let effectView = UIVisualEffectView(effect: effect)
        return effectView
    }()
    
    private let rootFlexContainer = UIView()
    var calendarView: CalendarView!
    var collectionView: UICollectionView!
    let showDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CustomText.showDetail, for: .normal)
        button.tintColor = .label
        button.isSelected = true
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        calendarView = CalendarView(initialContent: setupCalendarViewContents())
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        addSubview(effectView)
        effectView.contentView.addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .direction(.column)
            .alignItems(.end)
            .define { flex in
                flex.addItem(calendarView!)
                    .width(100%)
                    .grow(1)
                    .define { flex in
                        guard let calendar = flex.view as? CalendarView else { return }
                        calendar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                    }
                flex.addItem(collectionView)
                    .width(100%)
                    .height(100)
                flex.addItem(showDetailButton)
                    .right(0)
                    .height(50)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        effectView.pin.all()
        rootFlexContainer.pin.all(self.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}

//MARK: - Calender
extension CalendarContainerView {
    func setupCalendarViewContents(selected: Date? = nil, fetched: [Date] = []) -> CalendarViewContent {
        let calendar = Calendar.current
        let startDate = fetched.first ?? Date()
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

//MARK: - Collection View
extension CalendarContainerView {
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
        
        // Setcion Header
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
                                                                        elementKind: CalendarContainerView.sectionHeaderElementKind,
                                                                        alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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

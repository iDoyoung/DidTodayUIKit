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
    
    //MARK: Properties for Calendar
    var startDate: Date? = nil
    var selectedDate: Date?
    var datesOfDid = [Date]()
    
    init() {
        super.init(frame: .zero)
        calendarView = CalendarView(initialContent: setupCalendarViewContents())
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        addSubview(effectView)
        effectView.contentView.addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .direction(.column)
            .define { flex in
                flex.addItem(calendarView!)
                flex.addItem(collectionView)
                flex.addItem(showDetailButton)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootFlexContainer.pin.all(self.pin.safeArea)
        rootFlexContainer.flex.layout()
    }
}

//MARK: - Calender
extension CalendarContainerView {
    private func setupCalendarViewContents() -> CalendarViewContent {
        let calendar = Calendar.current
        let endDate = Date()
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: (startDate ?? Date())...endDate,
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
        .dayItemProvider { [weak self] day in
            var invariantViewProperties = DayLabel.InvariantViewProperties(font: .systemFont(ofSize: 14, weight: .semibold),
                                                                           textColor: .darkGray,
                                                                           backgroundColor: .clear)
            // Setup Today UI
            if day.components == calendar.dateComponents([.era, .year, .month, .day], from: Date()) {
                invariantViewProperties.textColor = .systemBackground
                invariantViewProperties.backgroundColor = .systemRed
            }
            
            if let self {
                // Setup Selected Day UI
                if calendar.date(from: day.components) == self.selectedDate {
                    invariantViewProperties.textColor = .systemBackground
                    invariantViewProperties.backgroundColor = .label
                }
                
                // Setup Fetched Day UI
                self.datesOfDid.forEach {
                    if calendar.date(from: day.components) == $0 {
                        invariantViewProperties.textColor = .customGreen
                        
                    }
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
                                                                        elementKind: CalendarViewController.sectionHeaderElementKind,
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

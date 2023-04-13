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
        //FIXME: - Calendar View에 Frame 적용하지 않을 경우 Breaking constraint waring 발생, width&height가 0일 경우에도 발생
        calendarView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        addSubview(effectView)
        effectView.contentView.addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .backgroundColor(.systemBackground)
            .direction(.column)
            .alignItems(.end)
            .cornerRadius(20)
            .border(0.5, .separator)
            .define { flex in
                flex.view?.shadowColor = .systemGray
                flex.view?.shadowOpacity = 0.2
                flex.view?.shadowRadius = 5
                flex.view?.shadowOffset = CGSize(width: 0, height: 5)
                flex.addItem(titleLabel)
                    .paddingVertical(20)
                    .start(20)
                    .width(100%)
                flex.addItem(calendarView)
                    .width(100%)
                    .grow(1)
                    .define { flex in
                        guard let calendar = flex.view as? CalendarView else { return }
                        calendar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                    }
                // Separator Line
                flex.addItem()
                    .backgroundColor(.separator)
                    .height(0.5)
                    .width(100%)
                flex.addItem(collectionView)
                    .width(100%)
                    .height(54)
                    .define { flex in
                        if let collectionView = flex.view as? UICollectionView {
                            collectionView.isScrollEnabled = false
                        }
                    }
                // Separator Line
                flex.addItem()
                    .backgroundColor(.separator)
                    .height(0.5)
                    .width(100%)
                flex.addItem(showDetailButton)
                    .right(20)
                    .height(50)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        effectView.pin.all()
        rootFlexContainer.pin
            .top(self.pin.safeArea)
            .bottom(self.pin.safeArea)
            .left(20)
            .right(20)
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                        leading: 10,
                                                        bottom: 10,
                                                        trailing: 10)
        
//        // Setcion Header
//        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
//        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize,
//                                                                        elementKind: CalendarContainerView.sectionHeaderElementKind,
//                                                                        alignment: .top)
//        section.boundarySupplementaryItems = [sectionHeader]
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

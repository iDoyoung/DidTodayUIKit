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
    
    let effectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemMaterial)
        let effectView = UIVisualEffectView(effect: effect)
        return effectView
    }()
    
    private let rootFlexContainer = UIView()
    let calendarView: CalendarView! = nil
    let collectionView: UICollectionView! = nil
    let showDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(CustomText.showDetail, for: .normal)
        button.tintColor = .label
        button.isSelected = true
        return button
    }()
    
    init() {
        super.init(frame: .zero)
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

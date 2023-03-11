//
//  DidDetails.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/10.
//

import UIKit
import PinLayout
import FlexLayout

final class DidDetailsView: UIView {
    
    private let rootFlexContainer = UIView()
    
    ///기록한 날짜
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let titleLabel: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        return textField
    }()
    
    let didTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let timeRangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customGreen
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        let backgroundColor = UIColor.gradientEffect(colors: [.customBackground, .secondaryCustomBackground],
                                                     frame: bounds,
                                                     startPoint: CGPoint(x: 0, y: 0),
                                                     endPoint: CGPoint(x: 1, y: 1)) ?? .customBackground
        
        addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .direction(.column)
            .define { flex in
                flex.addItem()
                    .backgroundColor(.systemGreen)
                    .marginBottom(8)
                    .paddingHorizontal(10)
                    .height(60)
                    .cornerRadius(10)
                    .backgroundColor(backgroundColor)
                    .border(1, .separator)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(dateLabel)
                    }
                
                flex.addItem()
                    .marginBottom(8)
                    .paddingHorizontal(10)
                    .height(60)
                    .cornerRadius(10)
                    .backgroundColor(backgroundColor)
                    .border(1, .separator)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(titleLabel)
                    }
                
                flex.addItem()
                    .marginBottom(8)
                    .paddingHorizontal(10)
                    .height(60)
                    .cornerRadius(10)
                    .backgroundColor(backgroundColor)
                    .border(1, .separator)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(didTimeLabel)
                    }
                
                flex.addItem()
                    .marginBottom(8)
                    .paddingHorizontal(10)
                    .height(60)
                    .cornerRadius(10)
                    .backgroundColor(backgroundColor)
                    .border(1, .separator)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(timeRangeLabel)
                    }
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
struct DidDetailsPreview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = DidDetailsView()
            view.dateLabel.text = Date().toString()
            view.titleLabel.text = "It is Title, It is Title, It is Title"
            view.didTimeLabel.text = "Did 05:00"
            view.timeRangeLabel.text = "07:00 - 12:00"
            return view
        }
    }
}
#endif

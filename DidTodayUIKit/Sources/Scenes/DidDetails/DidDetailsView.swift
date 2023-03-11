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
    
    let effectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemMaterial)
        let effectView = UIVisualEffectView(effect: effect)
        return effectView
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        return label
    }()
    
    let didTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let timeRangeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customGreen
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(effectView)
        effectView.contentView.addSubview(rootFlexContainer)
        rootFlexContainer.flex
            .direction(.column)
            .justifyContent(.end)
            .define { flex in
                flex.addItem()
                    .padding(10)
                    .marginBottom(8)
                    .cornerRadius(10)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(dateLabel)
                    }
                
                flex.addItem()
                    .padding(10)
                    .cornerRadius(10)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(titleLabel)
                    }
                
                flex.addItem()
                    .paddingHorizontal(10)
                    .cornerRadius(10)
                    .justifyContent(.center)
                    .define { flex in
                        flex.addItem(didTimeLabel)
                    }
                
                flex.addItem()
                    .paddingHorizontal(10)
                    .cornerRadius(10)
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
        effectView.pin.all()
        rootFlexContainer.pin.all(self.pin.safeArea)
        rootFlexContainer.flex.layout(mode: .adjustHeight)
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

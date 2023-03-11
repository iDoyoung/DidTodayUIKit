//
//  UIViewPreview.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/10.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ makeView: @escaping () -> View) {
        view = makeView()
    }

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
    }
}
#endif

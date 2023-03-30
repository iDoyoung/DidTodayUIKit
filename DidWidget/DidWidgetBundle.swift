//
//  DidWidgetBundle.swift
//  DidWidget
//
//  Created by Doyoung on 2023/03/30.
//

import WidgetKit
import SwiftUI

@main
struct DidWidgetBundle: WidgetBundle {
    var body: some Widget {
        DidWidget()
        DidWidgetLiveActivity()
    }
}

//
//  DaysListRootView.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 5/9/24.
//

import SwiftUI

struct DaysListRootView: View {
    
    @State var items: [DaysListItem]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.date) {
                    DayListCellView(
                        dids: $0.dids,
                        month: $0.date.month,
                        day: $0.date.day,
                        year: $0.date.year
                    )
                }
            }
        }
    }
}

#Preview {
    var mockItems = [
        DaysListItem(
            date: Date(),
            dids: [
                Did(started: Calendar.current.startOfDay(for: Date()),
                    finished: Date(),
                    content: "1",
                    color: .green
                   ),
                Did(
                    started: Calendar.current.startOfDay(for: Date()),
                    finished: Date(),
                    content: "2",
                    color: .blue
                )
            ]
        ),
        DaysListItem(
            date: Date(),
            dids: [
                Did(started: Calendar.current.startOfDay(for: Date()),
                    finished: Date(),
                    content: "1",
                    color: .green
                   ),
                Did(
                    started: Calendar.current.startOfDay(for: Date()),
                    finished: Date(),
                    content: "2",
                    color: .blue
                )
            ]
        )
    ]
    
    return DaysListRootView(items: mockItems)
}

//
//  DaysListRootView.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 5/9/24.
//

import SwiftUI

struct DaysListRootView: View {
    
    @State var items: [DaysListItem]
    var action: DaysListAction
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.date) { day in
                    DayListCellView(
                        dids: day.dids,
                        month: day.date.month,
                        day: day.date.day,
                        year: day.date.year
                    )
                    .onTapGesture {
                        action.selectDate(day.date)
                    }
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
    
    return DaysListRootView(items: mockItems, action: .init())
}

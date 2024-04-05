import SwiftUI

struct TodayRootView: View {
   
    @ObservedObject var updater: TodayViewUpdater
    
    var body: some View {
        GeometryReader { geomtry in
            ScrollView {
                VStack(alignment: .leading) {
                    remindersView
                        .padding(.vertical, 10)
                        .task {
                            do {
                                try await updater.getIsAccessOfReminders()
                                try await updater.readReminders()
                            } catch {
                                
                            }
                        }
                    
                    todayDidsView
                        .task {
                            do {
                                try await updater.readDids()
                            } catch {
                                
                            }
                        }
                }
            }
            .background(.blue)
            .frame(minHeight: geomtry.size.height)
        }
    }
    
    @ViewBuilder
    var remindersView: some View {
        if updater.viewModel.isAccessReminders {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(updater.viewModel.reminders) {
                        ReminderCell(reminder: $0)
                    }
                }
            }
        } else {
            NotAccessRemindersAuthorizationStatusView()
        }
    }
    
    var todayDidsView: some View {
        LazyVStack {
            ForEach(updater.viewModel.dids) {
                TodayDidsCell(did: $0)
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
        .overlay(alignment: .center) {
            if updater.viewModel.dids.isEmpty {
                Text(CustomText.didNothing)
                    .foregroundStyle(.secondary)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    var model = TodayViewUpdater()
    model.viewModel.isAccessReminders = false
    
    model.viewModel.lastestDid = Did(
        started: Date(),
        finished: Date(),
        content: "Test",
        color: .init(red: 1, green: 0, blue: 0, alpha: 1)
    )
    
    model.viewModel.dids = [
        Did(
            started: Date(),
            finished: Date(),
            content: "Frist Did",
            color: .init(red: 0, green: 1, blue: 0, alpha: 1)
        ),
        Did(
            started: Date(),
            finished: Date(),
            content: "Second Did",
            color: .init(red: 0, green: 0, blue: 1, alpha: 1)
        ),
        Did(
            started: Date(),
            finished: Date(),
            content: "Third Did",
            color: .init(red: 1, green: 0, blue: 1, alpha: 1)
        )
    ]
    
    model.viewModel.reminders = [
        Reminder(
            title: "Sample 1",
            dueDate: Date(),
            themeColor: CGColor(
                red: 0.5,
                green: 0.5,
                blue: 0.5,
                alpha: 1)
        ),
        Reminder(
            title: "Sample 2",
            dueDate: Date(),
            themeColor: CGColor(
                red: 0.5,
                green: 1,
                blue: 0.5,
                alpha: 1)
        ),
    ]
    return TodayRootView(updater: model)
}

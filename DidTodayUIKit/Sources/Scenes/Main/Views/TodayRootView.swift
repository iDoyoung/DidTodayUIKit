import SwiftUI

struct TodayRootView: View {
   
    @ObservedObject var model: TodayViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 0) {
                // Display Reminder
                remindersView
                
                //TODO: Draw Completed Today Reminders But Did Not Save In This App
                
                // Today Dids
                ForEach(model.dids) {
                    TodayDidsCell(did: $0)
                }
            }
        }
    }
    
    @ViewBuilder
    var remindersView: some View {
        if model.isAccessReminders {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(model.reminders) {
                        ReminderCell(reminder: $0)
                    }
                }
            }
            .padding(10)
        } else {
            NotAccessRemindersAuthorizationStatusView()
        }
    }
}

#Preview {
    var model = TodayViewModel()
    model.isAccessReminders = true
    
    model.lastestDid = Did(
        started: Date(),
        finished: Date(),
        content: "Test",
        color: .init(red: 1, green: 0, blue: 0, alpha: 1)
    )
    
    model.dids = [
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
    
    model.reminders = [
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
    return TodayRootView(model: model)
}

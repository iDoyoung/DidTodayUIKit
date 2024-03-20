import SwiftUI

struct TodayRootView: View {
   
    @ObservedObject var model: TodayViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                // Display Reminder
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(model.reminders) {
                            ReminderCell(reminder: $0)
                        }
                    }
                }
                .padding(10)
                .background(.green)
            }
        }
    }
}

#Preview {
    var model = TodayViewModel()
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

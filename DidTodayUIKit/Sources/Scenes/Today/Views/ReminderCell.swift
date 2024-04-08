import SwiftUI

struct ReminderCell: View {
    
    @State var reminder: Reminder
    
    var body: some View {
        content
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Color(cgColor: reminder.themeColor),
                        Color(cgColor: reminder.themeColor.brighter(by: 1.3))
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(reminder.title)
            Text("미리 알림 - \(reminder.dueDate.currentTimeToString())")
                .font(.footnote)
        }
    }
}

#Preview {
    ReminderCell(reminder: Reminder(
        title: "Sample",
        dueDate: Date(),
        themeColor: .init(red: 1, green: 0.5, blue: 0, alpha: 1)
    )
    )
}

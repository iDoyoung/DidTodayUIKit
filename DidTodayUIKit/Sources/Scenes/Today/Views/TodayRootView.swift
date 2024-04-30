import SwiftUI

struct TodayRootView: View {
   
    @State var reminders: FetchedReminders
    @State var dids: FetchedDids
    var action: TodayAction
    
    var body: some View {
        GeometryReader { geomtry in
            ScrollView {
                LazyVStack(alignment: .leading) {
                    remindersView
                        .padding(.vertical, 10)
                    
                    todayDidsView
                }
            }
            .frame(minHeight: geomtry.size.height)
            .overlay(alignment: .center) {
                if dids.items.isEmpty {
                    Text(CustomText.didNothing)
                        .foregroundStyle(.secondary)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: action.tapCreate) {
                    HStack {
                        Text(CustomText.did)
                        Image(systemName: "plus")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .shadow(
                    radius: 3,
                    y: 1
                )
                .padding()
            }
        }
    }
    
    @ViewBuilder
    var remindersView: some View {
        if reminders.isAccessReminders {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(reminders.items) {
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
            ForEach(dids.items) { did in
                TodayDidsCell(did: did)
                    .onTapGesture { _ in
                        action.selectDid(did)
                    }
            }
        }
        .frame(maxHeight: .infinity, alignment: .center)
    }
}

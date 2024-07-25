import SwiftUI

struct DayDetailsRootView: View {
    
    @State var dids: [Did]
    
    var body: some View {
        VStack {
            ScrollView {
                
                LazyVStack(content: {
                    ForEach(dids, id: \.id) { did in
                        TodayDidsCell(did: did)
                    }
                })
            }
        }
    }
}

#Preview {
    var dids = [
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 1", color: .systemRed),
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 2", color: .systemBlue),
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 3", color: .systemGray)
    ]

    return DayDetailsRootView(dids: dids)
}

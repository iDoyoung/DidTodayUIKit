import SwiftUI

struct DayListCellView: View {
    
    @State var dids: [Did]
    @State var month: String
    @State var day: String
    @State var year: String
    
    var color: Color {
        dids.first?.color ?? Color(uiColor: .systemBackground)
    }
    
    var body: some View {
        HStack {
            VStack {
                Text(year)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.vertical, 1)
                
                Text(month)
                    .font(
                        .system(
                            size: 30,
                            weight: .medium,
                            design: .rounded
                        )
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.bottom, -30)
                
                Text(day)
                    .font(
                        .system(
                            size: 60,
                            weight: .medium,
                            design: .rounded
                        )
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.bottom)
            }
            .padding(.leading)
            
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 2, height: 100)
                .padding()
            
            DidsSimpleChartView(dids: $dids)
                .padding(.top)
        }
        .padding()
        .background(color.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

#Preview {
    
    @State var date = Date().toString()
    @State var count = 5
    @State var color = Color.blue
    @State var dids = [
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 1", color: .systemRed),
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 2", color: .systemBlue),
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 3", color: .systemGray)
    ]
    
    return DayListCellView(
        dids: dids,
        month: "May",
        day: "5",
        year: "2024"
    )
}

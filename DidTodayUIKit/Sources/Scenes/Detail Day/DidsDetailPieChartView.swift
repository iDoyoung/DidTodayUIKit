import SwiftUI
import Charts

struct DidsDetailPieChartView: View {
    @Binding var dids: [Did]
    
    var body: some View {
        Chart(dids.chartData, id: \.title) { element in
            SectorMark(
                angle: .value("Times", element.times),
                innerRadius: .ratio(0.618),
                angularInset: 1
            )
            .foregroundStyle(by: .value("Did", element.title))
            .cornerRadius(10)
        }
        .chartForegroundStyleScale(range: dids.map({ $0.color }))
        .chartBackground { proxy in
            Text("Percentage Of Did")
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("\(dids.count)")
        }
    }
}


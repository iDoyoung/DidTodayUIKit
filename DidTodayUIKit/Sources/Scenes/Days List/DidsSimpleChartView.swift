import SwiftUI
import Charts

struct DidsSimpleChartView: View {
    @Binding var dids: [Did]
    
    var body: some View {
        VStack {
            Text("did \(dids.count)")
                .font(.system(size: 20))
            
            DidsSimpleChart(dids: $dids)
                .frame(maxWidth: 66 ,maxHeight: 66)
        }
    }
}

private struct DidsSimpleChart: View {
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
        .chartLegend(.hidden)
    }
}

extension Array<Did> {
    struct DidChartData {
        var title: String
        var times: Int
        var color: Color
    }
    
    var chartData: [DidChartData] {
        return self.map {
            DidChartData(
                title: $0.content,
                times: Date.differenceToMinutes(from: $0.started, to: $0.finished),
                color: $0.color
            )
        }
    }
}

#Preview {
    @State var dids = [
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 1", color: .systemRed),
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 2", color: .systemBlue),
        Did(started: Calendar.current.startOfDay(for: Date()), finished: .init(), content: "Did 3", color: .systemGray)
    ]

    return DidsSimpleChartView(dids: $dids)
}

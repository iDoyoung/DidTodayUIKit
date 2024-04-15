import SwiftUI

struct DidDetailsRootView: View {
    
    @State var did: Did
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // Title
                    Text(did.content)
                        .padding(.top, 40)
                        .font(.system(size: 50, weight: .bold))
                    
                    Text("\(did.started.currentTimeToString())-\(did.finished.currentTimeToString())")
                    
                    Rectangle()
                        .background(Color(uiColor: .black))
                        .frame(height: 2)
                    
                    Text(Date.differenceToString(from: Date(), to: Date()))
                        .font(.system(size: 50, weight: .medium))
                    
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
            .background(.background)
            .padding(20)
        }
        .background(Color(
            red: Double(did.pieColor.red),
            green: Double(did.pieColor.green),
            blue: Double(did.pieColor.blue))
        )
    }
}

#Preview {
    DidDetailsRootView(did: Did(
        started: Date(),
        finished: Date(),
        content: "Develop Did Project",
        color: .init(
            red: 0,
            green: 1,
            blue: 1,
            alpha: 1
        ))
    )
}

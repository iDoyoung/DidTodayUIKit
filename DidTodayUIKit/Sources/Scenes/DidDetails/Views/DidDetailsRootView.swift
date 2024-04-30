import SwiftUI

struct DidDetailsRootView: View {
    
    @State var did: Did
    
    var body: some View {
        ZStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        Text(did.content)
                            .padding(.top, 40)
                            .font(.system(size: 50, weight: .bold))
                        
                        Text("\(did.started)")
                        
                        Rectangle()
                            .background(Color(uiColor: .black))
                            .frame(height: 2)
                        
                        Text(Date.differenceToString(from: did.started, to: did.finished))
                            .font(.system(size: 50, weight: .medium))
                    }
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                }
                .background(.background)
                .padding()
        }
        .background(did.color)
    }
}

#Preview {
    DidDetailsRootView(
                       did: Did(
                        started: Date(),
                        finished: Date(),
                        content: "Mock Did",
                        color: .systemRed
                       )
    )
}

import SwiftUI

struct TodayDidsCell: View {
    
    @State var did: Did
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(did.color())
                .frame(width: 4)
            VStack(alignment: .leading) {
                Text(did.content)
                    .fontWeight(.medium)
                Text(Date.differenceToString(from: did.started, to: did.finished))
                    .font(.caption)
                    .foregroundStyle(did.color())
                    .padding(.bottom, 12)
                Divider()
            }
            .padding(.top, 8)
            .padding(.leading, 6)
        }
    }
}


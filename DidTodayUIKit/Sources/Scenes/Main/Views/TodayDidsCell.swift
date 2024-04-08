import SwiftUI

struct TodayDidsCell: View {
    
    @State var did: Did
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(did.color)
                .frame(width: 6)
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text(did.content)
                    .fontWeight(.medium)
                Text(Date.differenceToString(from: did.started, to: did.finished))
                    .font(.caption)
                    .foregroundStyle(did.color)
                    .padding(.bottom, 12)
                Divider()
            }
            .padding(.top, 8)
            .frame(alignment: .leading)
        }
    }
}

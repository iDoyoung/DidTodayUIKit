import SwiftUI

struct DidsListRootView: View {
    
    @State var dids: FetchedDids
    
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(dids.items, id: \.id) { item in
                    buildCell(item: item)
                        .aspectRatio(1, contentMode: .fill)
                }
            }
        }
    }
    
    private func buildCell(item: Did) -> some View {
        var cell: some View {
            GeometryReader(content: { geometry in
                let cellLength = geometry.size.width
                VStack(alignment: .leading) {
                    Spacer()
                    Text(item.content)
                        .font(.system(size: 20, weight: .medium))
                        .padding([.leading, .bottom], 10)
                }
                .frame(width: cellLength, height: cellLength, alignment: .leading)
                .background(Color(uiColor: item.uiColor))
            })
        }
        
        return cell
    }
}

#Preview {
    let fetchedDidsMock = FetchedDids()
    fetchedDidsMock.items = [
        Did(
        started: Date(),
        finished: Date(),
        content: "It is Test Mock One",
        color: .red
        ),
        Did(
        started: Date(),
        finished: Date(),
        content: "It is Test Mock Seconde",
        color: .red
        ),
        Did(
        started: Date(),
        finished: Date(),
        content: "It is Test Mock Third",
        color: .red
        ),
        Did(
        started: Date(),
        finished: Date(),
        content: "It is Test Mock 4th",
        color: .red
        ),
        Did(
        started: Date(),
        finished: Date(),
        content: "It is Test Mock 5th",
        color: .red
        ),
        Did(
        started: Date(),
        finished: Date(),
        content: "It is Test Mock 6th",
        color: .red
        ),
    ]
    
    return DidsListRootView(dids: fetchedDidsMock)
}

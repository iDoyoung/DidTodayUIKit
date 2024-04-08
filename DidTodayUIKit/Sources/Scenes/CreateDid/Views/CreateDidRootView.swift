import SwiftUI

struct CreateDidRootView: View {
    
    @State var selectedColor: Color = .green
    @State var title: String = ""
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            //Color Picker
            Button(action: {}, label: {
                Text("Set Color")
                    .font(.system(size: 40,
                                  weight: .black))
                Image(systemName: "paintpalette")
                    .frame( alignment: .trailing)
                    .font(.system(size: 40))
            })
            .buttonStyle(.borderedProminent)
            .tint(selectedColor)
            .padding(.vertical, 2)
            
            //Current Date
            Text(Date().toString())
                .font(.system(size: 40,
                              weight: .medium)
                )
                .padding(.vertical, 8)
            
            //Start Date Picker
            HStack {
                Text("시작 시간")
                    .font(.system(size: 12,
                                  weight: .semibold))
                    .padding()
                DatePicker("", selection: $startTime,
                           displayedComponents: [.hourAndMinute])
                Spacer()
            }
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.vertical, 2)
            
            //End Date Picker
            HStack {
                Text("종료 시간")
                    .font(.system(size: 12,
                                  weight: .semibold))
                    .padding()
                DatePicker("", selection: $endTime,
                           displayedComponents: [.hourAndMinute])
                Spacer()
            }
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.vertical, 2)
            
            TextField("Title", text: $title)
                .frame(height: 50)
                .padding(.vertical, 2)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .tint(Color(uiColor: .label))
                
            
            Spacer()
            
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "chevron.backward")
                        .frame(width: 40, height: 40)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(Circle())
                }
                .tint(Color(uiColor: .label))
                .shadow(
                    radius: 3,
                    y: 1
                )
                
                Spacer()
                
                Button(action: {}) {
                    Text(CustomText.create)
                        .fontWeight(.bold)
                }
                .tint(.black)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .shadow(
                    radius: 3,
                    y: 1
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CreateDidRootView()
}

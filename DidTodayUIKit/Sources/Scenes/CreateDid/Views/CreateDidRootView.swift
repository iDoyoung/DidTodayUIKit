import SwiftUI

struct CreateDidRootView: View {
    
    @ObservedObject var updater: CreateDidViewUpdater
    @State private var showAlert = false
    var presentColorPicker: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            //Color Picker
            Button(
                action: presentColorPicker,
                label: {
                    Text("Set Color")
                        .font(.system(size: 40,
                                      weight: .black))
                    Image(systemName: "paintpalette")
                        .frame( alignment: .trailing)
                        .font(.system(size: 40))
                })
            .buttonStyle(.borderedProminent)
            .tint(updater.viewModel.selectedColor)
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
                DatePicker("", selection: $updater.viewModel.startedTime,
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
                DatePicker("", selection: $updater.viewModel.finishedTime,
                           displayedComponents: [.hourAndMinute])
                Spacer()
            }
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.vertical, 2)
            
            TextField("Title", text: $updater.viewModel.title)
                .frame(height: 50)
                .padding(.vertical, 2)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .tint(Color(uiColor: .label))
                
            
            Spacer()
            
            HStack {
                Button(action: {
                    showAlert = true
                }) {
                    Image(systemName: "xmark")
                        .frame(width: 40, height: 40)
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(Circle())
                }
                .tint(Color(uiColor: .label))
                .shadow(
                    radius: 3,
                    y: 1
                )
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(CustomText.discardToCreateDidTitle),
                        message: Text(CustomText.discardToCreateDidMessage),
                        primaryButton: .destructive(
                            Text(CustomText.okay),
                            action: updater.cancel
                        ),
                        secondaryButton: .cancel()
                    )
                }
                
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
    var updater = CreateDidViewUpdater()
    return CreateDidRootView(updater: updater, 
                             presentColorPicker: {})
}

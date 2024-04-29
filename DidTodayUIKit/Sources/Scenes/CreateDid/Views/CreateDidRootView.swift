import SwiftUI

struct CreateDidRootView: View {
    
    @State var creating: Did
    @State var error: CreateDidError
    @State private var showAlert = false
    
    var action: CreateDidAction
   
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            //Color Picker
            Button(
                action: action.tapColorPickerButton,
                label: {
                    Text("Set Color")
                        .font(.system(size: 40,
                                      weight: .black))
                    Image(systemName: "paintpalette")
                        .frame( alignment: .trailing)
                        .font(.system(size: 40))
                }
            )
            .buttonStyle(.borderedProminent)
            .tint(Color(uiColor: creating.uiColor))
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
                DatePicker("", selection: $creating.started,
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
                DatePicker("", selection: $creating.finished,
                           displayedComponents: [.hourAndMinute])
                Spacer()
            }
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            .padding(.vertical, 2)
            
            TextField("Title", text: $creating.content)
                .frame(height: 50)
                .padding(.vertical, 2)
                .padding(.horizontal)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .tint(Color(uiColor: .label))
                .offset(x: error.type == .textFieldIsEmpty ? 5: 0)
            
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
                            action: action.close
                        ),
                        secondaryButton: .cancel()
                    )
                }
                
                Spacer()
                
                Button(action: action.tapCreateButton) {
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

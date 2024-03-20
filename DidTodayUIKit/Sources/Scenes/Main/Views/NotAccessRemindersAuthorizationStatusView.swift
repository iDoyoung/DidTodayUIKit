import SwiftUI

struct NotAccessRemindersAuthorizationStatusView: View {
    
    var body: some View {
        ZStack {
            HStack {
                Text("미리 알림을 가져오려면 설정에서 Did가 사용할 수 있도록 허용해주세요.")
                    .font(.callout)
                    .foregroundStyle(Color(uiColor: .systemBackground))
                settingButton
            }
            .padding(16)
            .background(Color(uiColor: .label))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    var settingButton: some View {
        Button {
        } label: {
            Text("설정")
                .fontWeight(.semibold)
                .frame(width: 80)
        }
        .padding(10)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .foregroundStyle(Color(uiColor: .label))
    }
}

#Preview {
    NotAccessRemindersAuthorizationStatusView()
}

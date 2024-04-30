import Foundation

final class TodayAction {
    
    @Published var isTapCreate: Bool = false
    @Published var selectedDid: Did? = nil
    
    func tapCreate() {
        isTapCreate = true
    }
    
    func selectDid(_ did: Did) {
        selectedDid = did
    }
}

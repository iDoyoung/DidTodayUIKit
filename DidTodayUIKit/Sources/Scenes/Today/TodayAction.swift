import Foundation

final class TodayAction {
    @Published var isTapCreate: Bool = false
    
    func tapCreate() {
        isTapCreate = true
    }
}


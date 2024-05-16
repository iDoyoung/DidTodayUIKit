import Foundation

final class DaysListAction {
    @Published var selectedDate: Date? = nil
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }
}

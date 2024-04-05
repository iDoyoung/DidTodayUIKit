import Foundation

struct TodayViewModel {
    var reminders = [Reminder]()
    var isAccessReminders: Bool = false
    var dids = [Did]()
    var lastestDid: Did?
}

final class TodayViewUpdater: ObservableObject {
   
    private var interactor: TodayInteractor!
    
    @Published var viewModel: TodayViewModel = TodayViewModel()
   
    func loadView() {
        Task {
            try await interactor.execute(useCase: .getRemindersAuthorizationStatus,
                                         viewModel: &viewModel)
        }
    }
    
    func request() {
        
    }
}

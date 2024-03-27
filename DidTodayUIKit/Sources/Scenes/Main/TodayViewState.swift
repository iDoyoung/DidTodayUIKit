import Foundation

struct TodayViewModel {
    var reminders = [Reminder]()
    var isAccessReminders: Bool = false
    var dids = [Did]()
    var lastestDid: Did?
}

final class TodayViewState: ObservableObject {
   
    var interactor: TodayInteractor!
    
    @Published var viewModel: TodayViewModel = TodayViewModel()
   
    func loadView() {
        Task {
            try await interactor.execute(useCase: .readDids, viewModel: &viewModel)
            try await interactor.execute(useCase: .readReminders, viewModel: &viewModel)
        }
    }
}

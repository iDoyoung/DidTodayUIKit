import Foundation

struct TodayViewModel {
    var reminders = [Reminder]()
    var isAccessReminders: Bool = false
    var dids = [Did]()
    var lastestDid: Did?
}

final class TodayViewUpdater: ObservableObject {
   
    private var interactor: TodayInteractor?
    
    @Published var viewModel: TodayViewModel = TodayViewModel()
   
    init(interactor: TodayInteractor? = nil) {
        self.interactor = interactor
    }
   
    @MainActor
    func getIsAccessOfReminders() async throws {
        try await interactor?.execute(
            useCase: .getRemindersAuthorizationStatus,
            viewModel: &viewModel
        )
    }
    
    func requestAccessOfReminders() async throws {
        try await interactor?.execute(
            useCase: .requestAccessOfReminders,
            viewModel: &viewModel
        )
    }
    
    @MainActor
    func readReminders() async throws {
        try await interactor?.execute(
            useCase: .readReminders,
            viewModel: &viewModel
        )
    }
    
    @MainActor
    func readDids() async throws {
        try await interactor?.execute(
            useCase: .readDids,
            viewModel: &viewModel
        )
    }
    
    func showCreateDid() {
        Task { @MainActor in
            try await interactor?.execute(
                useCase: .createDid,
                viewModel: &viewModel
            )
        }
    }
}

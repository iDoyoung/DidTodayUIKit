import Foundation

struct TodayInteractor {
    
    private var requestAccessOfRemindersUseCase: RequestAccessOfReminderUseCaseProtocol
    private var readRemindersUseCase: ReadReminderUseCaseProtocol
    private var fetchDidsUseCase: FetchDidUseCase
    
    init(requestAccessOfRemindersUseCase: RequestAccessOfReminderUseCaseProtocol,
         readRemindersUseCase: ReadReminderUseCaseProtocol,
         fetchDidsUseCase: FetchDidUseCase) {
        self.requestAccessOfRemindersUseCase = requestAccessOfRemindersUseCase
        self.readRemindersUseCase = readRemindersUseCase
        self.fetchDidsUseCase = fetchDidsUseCase
    }
    
    func execute(useCase: TodayUseCase,
                 viewModel: inout TodayViewModel) async throws {
        switch useCase {
        case .requestAccessOfReminders:
            try await requestAccessOfRemindersUseCase.excute()
        case .readReminders:
            viewModel.reminders = try await readRemindersUseCase.excute()
        case .readDids:
            viewModel.dids = try await fetchDidsUseCase.execute()
        }
    }
}

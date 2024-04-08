import Foundation

struct TodayInteractor {
    
    private var getRemindersAuthorizationStatusUseCase: GetRemindersAuthorizationStatusUseCaseProtocol
    private var requestAccessOfRemindersUseCase: RequestAccessOfReminderUseCaseProtocol
    private var readRemindersUseCase: ReadReminderUseCaseProtocol
    private var fetchDidsUseCase: FetchDidUseCase
    
    init(
        getRemindersAuthorizationStatusUseCase: GetRemindersAuthorizationStatusUseCaseProtocol,
        requestAccessOfRemindersUseCase: RequestAccessOfReminderUseCaseProtocol,
        readRemindersUseCase: ReadReminderUseCaseProtocol,
        fetchDidsUseCase: FetchDidUseCase
    ) {
        self.getRemindersAuthorizationStatusUseCase = getRemindersAuthorizationStatusUseCase
        self.requestAccessOfRemindersUseCase = requestAccessOfRemindersUseCase
        self.readRemindersUseCase = readRemindersUseCase
        self.fetchDidsUseCase = fetchDidsUseCase
    }
    
    func execute(useCase: TodayUseCase,
                 viewModel: inout TodayViewModel) async throws {
        switch useCase {
        case .getRemindersAuthorizationStatus:
            viewModel.isAccessReminders = try await getRemindersAuthorizationStatusUseCase.execute()
        case .requestAccessOfReminders:
            try await requestAccessOfRemindersUseCase.execute()
        case .readReminders:
            viewModel.reminders = try await readRemindersUseCase.excute()
        case .readDids:
            viewModel.dids = try await fetchDidsUseCase.execute()
        }
    }
}

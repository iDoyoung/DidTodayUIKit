import Foundation

protocol RequestAccessOfReminderUseCaseProtocol {
    func execute() async throws 
}

final class RequestAccessOfReminderUseCase: RequestAccessOfReminderUseCaseProtocol {
    
    private let stroage: ReminderStoreProtocol
    
    init(stroage: ReminderStoreProtocol) {
        self.stroage = stroage
    }
    
    func execute() async throws {
        try await stroage.requestAccess()
    }
}

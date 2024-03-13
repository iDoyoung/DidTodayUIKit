import Foundation

protocol RequestAccessOfReminderUseCaseProtocol {
    func excute() async throws 
}

final class RequestAccessOfReminderUseCase: RequestAccessOfReminderUseCaseProtocol {
    
    private let stroage: ReminderStoreProtocol
    
    init(stroage: ReminderStoreProtocol) {
        self.stroage = stroage
    }
    
    func excute() async throws {
        try await stroage.requestAccess()
    }
}

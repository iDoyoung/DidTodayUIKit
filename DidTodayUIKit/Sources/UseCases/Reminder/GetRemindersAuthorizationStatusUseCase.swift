import Foundation

protocol GetRemindersAuthorizationStatusUseCaseProtocol {
    func execute() async throws -> Bool
}

struct GetRemindersAuthorizationStatusUseCase: GetRemindersAuthorizationStatusUseCaseProtocol {
    
    private let storage: ReminderStoreProtocol
    
    init(storage: ReminderStoreProtocol) {
        self.storage = storage
    }
    
    func execute() async throws -> Bool {
        return storage.isAvailable
    }
}

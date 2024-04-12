import Foundation

struct CreateDidInteractor {
    
    private var router: CreateDidRouter
    private var createDidUseCase: CreateDidUseCase?
    
    init(
        router: CreateDidRouter,
        createDidUseCase: CreateDidUseCase
    ) {
        self.router = router
        self.createDidUseCase = createDidUseCase
    }
    
    func create(did: Did) async throws {
        try await createDidUseCase?.execute(did)
    }
    
    func cancel() {
        router.dismiss()
    }
}

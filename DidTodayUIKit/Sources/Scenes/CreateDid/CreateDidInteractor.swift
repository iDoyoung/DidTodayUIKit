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
    
    func execute(action: CreateDidAction,
                 with viewModel: inout CreateDidViewModel) async throws {
        switch action {
        case .createDid:
            if let colorComponents = viewModel.selectedColor.cgColor?.components {
                let components = colorComponents.map { Float($0) }
                let did = Did(withTimer: viewModel.isTimer,
                              started: viewModel.startedTime,
                              finished: viewModel.finishedTime,
                              content: viewModel.title,
                              color: .init(red: components[0],
                                           green: components[1],
                                           blue: components[2],
                                           alpha: components[3])
                )
                try await createDidUseCase?.execute(did)
            }
        case .cancel:
            DispatchQueue.main.async {
                router.dismiss()
            }
        }
    }
}

import SwiftUI

struct CreateDidViewModel {
    var isTimer = false
    var title: String = ""
    var startedTime: Date = Date()
    var finishedTime: Date = Date()
    var selectedColor: Color = .green
}

final class CreateDidViewUpdater: ObservableObject {
    
    typealias ViewModel = CreateDidViewModel
    private var interactor: CreateDidInteractor?
    
    @Published var viewModel = ViewModel()
    
    init(interactor: CreateDidInteractor? = nil) {
        self.interactor = interactor
    }
    
    func cancel()  {
        Task { @MainActor in
            try await interactor?.execute(
                action: .cancel,
                with: &viewModel
            )
        }
    }
    
    func create() async throws {
    }
}

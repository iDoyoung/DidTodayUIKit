import SwiftUI
import Combine

struct CreateDidViewModel {
    var isTimer = false
    var title: String = ""
    var startedTime: Date = Date()
    var finishedTime: Date = Date()
    var selectedColor: UIColor = .green
}

final class CreateDidViewUpdater: ObservableObject {
    
    typealias ViewModel = CreateDidViewModel
    
    @Published var viewModel = ViewModel()
    
    private var interactor: CreateDidInteractor?
    
    init(interactor: CreateDidInteractor? = nil) {
        self.interactor = interactor
        
    }
    
    func cancel()  {
        interactor?.cancel()
    }
    
    func create() async throws {
        let colorComponents = viewModel.selectedColor.cgColor.components?.compactMap { Float($0) }
        guard let colorComponents else { return }
        let did = Did(
            started: viewModel.startedTime,
            finished: viewModel.finishedTime,
            content: viewModel.title,
            color: .init(
                red: colorComponents[0],
                green: colorComponents[1],
                blue: colorComponents[2],
                alpha: colorComponents[3]
            )
        )
        try await interactor?.create(did: did)
    }
}

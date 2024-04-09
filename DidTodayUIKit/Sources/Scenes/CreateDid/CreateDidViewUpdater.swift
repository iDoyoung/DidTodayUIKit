import Foundation

struct CreateDidViewModel {
    
}

final class CreateDidViewUpdater: ObservableObject {
    
    typealias ViewModel = CreateDidViewModel
    private var interactor: CreateDidInteractor?
    
    @Published var viewModel = ViewModel()
    
    init(interactor: CreateDidInteractor? = nil) {
        self.interactor = interactor
    }
}

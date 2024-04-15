import Foundation

struct DidDetailsViewModel {
    
}

final class DidDetailsViewUpdater: ObservableObject {
    
    private var interactor: DidDetailsInteractor?
    
    @Published var viewModel = DidDetailsViewModel()
    
    init(interactor: DidDetailsInteractor? = nil) {
        self.interactor = interactor
    }
}

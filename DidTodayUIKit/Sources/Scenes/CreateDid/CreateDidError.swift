import Foundation

@Observable
final class CreateDidError {
    enum ErrorType {
        case textFieldIsEmpty
        case none
    }
    
    var type: ErrorType = .none
}

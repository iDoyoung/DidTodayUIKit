import Foundation
import os

final class CreateDidAction {
   
    private let logger = Logger()
    
    @Published var isTapCreateButton = false
    @Published var isTapColorPickerButton = false
    @Published var isClose = false
    
    func tapCreateButton() {
        isTapCreateButton = true
        logger.log("Tap Create Button, \(self.isTapCreateButton)")
    }
    
    func tapColorPickerButton() {
        isTapColorPickerButton = true
        logger.log("Tap Color Picker Button, \(self.isTapColorPickerButton)")
    }
    
    func close() {
        isClose.toggle()
    }
}

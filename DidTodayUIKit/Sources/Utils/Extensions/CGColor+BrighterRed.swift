import UIKit

extension CGColor {
   
    func brighter(by factor: CGFloat) -> CGColor {
        guard let components = self.components else {
            return self
        }
        
        var adjustedComponents = components
        
        // Adjust each component by multiplying it with the given factor
        for i in 0..<components.count {
            adjustedComponents[i] = min(components[i] * factor, 1.0)
        }
        
        // Create a new CGColor with the adjusted components
        if let colorSpace = self.colorSpace {
            return CGColor(colorSpace: colorSpace, components: adjustedComponents) ?? self
        } else {
            return self
        }
    }
}

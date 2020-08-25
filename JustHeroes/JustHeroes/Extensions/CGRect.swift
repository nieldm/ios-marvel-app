import Foundation
import UIKit

extension CGRect {
    func divide(
        by number: CGFloat,
        withSpacing spacing: CGFloat = 0,
        withAspect aspect: CGFloat = 0,
        maxSize: CGFloat = .infinity) -> CGSize {
        
        let proportion: CGFloat = 1.0 / number
        let spacing = spacing * (number - 1.0)
        let newWidth = min((width * proportion) - spacing, maxSize)
        
        return CGSize(width: newWidth, height: newWidth * aspect)
    }
}

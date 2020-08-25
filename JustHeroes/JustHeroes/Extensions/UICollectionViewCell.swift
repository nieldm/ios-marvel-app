import Foundation
import UIKit

extension UICollectionViewCell {
    func addBorderAndCornerToCell(withFrame frame: CGRect) {
        contentView.backgroundColor = .cellBackground
        contentView.layer.rounded()
        
        layer.shadow()
    }
}

extension CALayer {
    func rounded(withCornerRadius corner: CGFloat = 6, andBorderWidth border: CGFloat = 1) {
        cornerRadius = corner
        borderColor = UIColor.cellBackground.cgColor
        borderWidth = border
        masksToBounds = true
    }
    
    func shadow() {
        shadowColor = UIColor.secondary.cgColor
        shadowOpacity = 0.15
        masksToBounds = false
        shadowPath = CGPath(
            roundedRect: CGRect(origin: .init(x: -1, y: -1), size: frame.size),
            cornerWidth: 6,
            cornerHeight: 0,
            transform: nil
        )
        shadowOffset = .zero
    }
}

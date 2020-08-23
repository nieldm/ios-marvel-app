import Foundation
import UIKit

extension UICollectionViewCell {
    func addBorderAndCornerToCell(withFrame frame: CGRect) {
        contentView.backgroundColor = .cellBackground
        contentView.layer.rounded()
        
        layer.shadowColor = UIColor.secondary.cgColor
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        layer.shadowPath = CGPath(
            roundedRect: CGRect(origin: .init(x: -1, y: -1), size: frame.size),
            cornerWidth: 6,
            cornerHeight: 0,
            transform: nil
        )
        layer.shadowOffset = .zero
    }
}

extension CALayer {
    func rounded(withCornerRadius corner: CGFloat = 6, andBorderWidth border: CGFloat = 1) {
        cornerRadius = corner
        borderColor = UIColor.cellBackground.cgColor
        borderWidth = border
        masksToBounds = true
    }
}

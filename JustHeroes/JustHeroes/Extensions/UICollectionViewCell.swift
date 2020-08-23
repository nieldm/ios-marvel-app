import Foundation
import UIKit

extension UICollectionViewCell {
    func addBorderAndCornerToCell(withFrame frame: CGRect) {
        contentView.backgroundColor = .cellBackground
        contentView.layer.cornerRadius = 6
        contentView.layer.borderColor = UIColor.cellBackground.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        
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

import Foundation
import UIKit

struct CardCollectionItem: CollectionViewItem {
    
    typealias Cell = CardCollectionViewCell
    
    func prepare(cell: CardCollectionViewCell) -> UICollectionViewCell {
        cell
    }
    
    func getSize() -> CGSize {
        CGSize(width: 250, height: 265)
    }
}

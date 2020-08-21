import Foundation
import UIKit

extension String: CollectioViewModel {}

struct CardCollectionItem: CollectionViewItem {

    typealias Model = String
    typealias Cell = CardCollectionViewCell
        
    var model: Model
    
    func prepare(cell: CardCollectionViewCell) -> UICollectionViewCell {
        cell
    }
    
    func getSize() -> CGSize {
        CGSize(width: 250, height: 265)
    }
}

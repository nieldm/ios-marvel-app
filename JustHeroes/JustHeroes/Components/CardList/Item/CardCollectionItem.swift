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
        CGSize(width: 120, height: 250)
    }
}

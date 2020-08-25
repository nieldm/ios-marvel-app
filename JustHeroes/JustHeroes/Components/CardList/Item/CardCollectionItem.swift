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
    
    func getSize(_ collectionView: UICollectionView?) -> CGSize {
        return collectionView?.frame.divide(
            by: 3,
            withSpacing: 12,
            withAspect: 250 / 120,
            maxSize: 120
        ) ?? CGSize(width: 120, height: 250)
    }
}

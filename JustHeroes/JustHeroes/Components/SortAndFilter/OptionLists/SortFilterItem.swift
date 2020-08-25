import Foundation
import UIKit

class SortFilterItem: CollectionViewItem {
    typealias Cell = SimpleOptionCollectionViewCell
    typealias Model = SortFilterModel
    
    var model: SortFilterModel
    
    init(model: SortFilterModel) {
        self.model = model
    }
    
    func prepare(cell: SimpleOptionCollectionViewCell) -> UICollectionViewCell {
        cell.titleLabel.text = model.name
        return cell
    }
    
    func getSize(_ collectionView: UICollectionView?) -> CGSize {
        .init(
            width: collectionView?.frame.width.multipliedBy(0.9) ?? 200,
            height: 44
        )
    }
}

extension SortFilterModel: CollectioViewModel {}

extension CGFloat {
    func multipliedBy(_ number: CGFloat) -> CGFloat {
        self * number
    }
}

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
    
    func getSize() -> CGSize {
        .init(width: 200, height: 44)
    }
}

extension SortFilterModel: CollectioViewModel {}

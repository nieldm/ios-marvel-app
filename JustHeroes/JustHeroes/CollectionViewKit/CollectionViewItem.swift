import Foundation
import UIKit

protocol CollectioViewModel {}

protocol CollectionViewItem {
    
    associatedtype Cell: UICollectionViewCell
    associatedtype Model: CollectioViewModel
    
    var model: Model {get set}
    
    func prepare(cell: Cell) -> UICollectionViewCell
    func getSize() -> CGSize
    
}

import Foundation
import UIKit

protocol CollectionViewItem {
    
    associatedtype Cell: UICollectionViewCell
    
    func prepare(cell: Cell) -> UICollectionViewCell
    
}

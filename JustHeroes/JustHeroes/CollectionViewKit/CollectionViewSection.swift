import Foundation
import UIKit

protocol CollectionViewSection {
    
    associatedtype Item: CollectionViewItem
    
    var items: [Item] { get }
    var spacing: CGFloat { get }
    
    func preload(itemAt index: Int)
    func cancelPreload(itemAt index: Int)
    func getHeader() -> UICollectionReusableView
    func getFooter() -> UICollectionReusableView
}

import Foundation
import UIKit

protocol CollectionViewSection {
    
    associatedtype Item: CollectionViewItem
    
    associatedtype Header: UICollectionReusableView
    associatedtype Footer: UICollectionReusableView
    
    var items: [Item] { get }
    var spacing: CGFloat { get }
    
    func preload(itemAt index: Int)
    func cancelPreload(itemAt index: Int)
    
    func getHeaderSize(_ collectionView: UICollectionView) -> CGSize
    func getFooterSize(_ collectionView: UICollectionView) -> CGSize
    
    func getHeader(header: Header) -> Header
    func getFooter(footer: Footer) -> Footer
}
